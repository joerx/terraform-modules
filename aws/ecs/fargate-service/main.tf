locals {
  docker_secrets      = toset(compact([for c in var.containers : lookup(c, "docker_login", null)]))
  docker_secret_arns  = [for s in data.aws_secretsmanager_secret.docker_login : s.arn]
  docker_kms_key_arns = [for k in data.aws_kms_key.docker_login : k.arn]
}

module "labels" {
  source  = "http://tfmodules.lolcatz.de/global/naming-v1.3.tar.gz"
  context = var.labels
}

# See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/private-auth.html
data "aws_secretsmanager_secret" "docker_login" {
  for_each = local.docker_secrets
  name     = each.value
}

data "aws_kms_key" "docker_login" {
  for_each = local.docker_secrets
  key_id   = data.aws_secretsmanager_secret.docker_login[each.key].kms_key_id
}

data "aws_region" "current" {}

# Log group to send logs to
resource "aws_cloudwatch_log_group" "task_logs" {
  name              = "${module.labels.namespace}-ecs-logs"
  retention_in_days = 5
  tags              = module.labels.tags
}

locals {
  default_log_driver = "awslogs"
  default_log_options = {
    awslogs-group  = aws_cloudwatch_log_group.task_logs.name
    awslogs-region = data.aws_region.current.name
  }

  container_definitions = [for c in var.containers :
    {
      name      = c["name"]
      image     = c["image"]
      essential = lookup(c, "essential", true)
      command   = lookup(c, "command", null)

      environment = [for k, v in lookup(c, "environment", {}) : {
        name : k,
        value : v
      }]

      cpu               = lookup(c, "cpu", 0)
      memory            = lookup(c, "memory", null)
      memoryReservation = lookup(c, "memory_reservation", null)

      repositoryCredentials = lookup(c, "docker_login", null) != null ? {
        credentialsParameter = data.aws_secretsmanager_secret.docker_login[c["docker_login"]].arn
      } : null

      firelensConfiguration = lookup(c, "firelens_configuration", null) != null ? {
        type = c["firelens_configuration"]["type"]
      } : null

      portMappings = [for p in lookup(c, "ports", []) : {
        containerPort = p
        hostPort      = p
      }]

      logConfiguration = {
        logDriver = lookup(c, "log_driver", local.default_log_driver)
        options   = lookup(c, "log_options", merge(local.default_log_options, { "awslogs-stream-prefix" : c["name"] }))
      }
    }
  ]
}

resource "aws_ecs_task_definition" "task" {
  family             = module.labels.namespace
  execution_role_arn = aws_iam_role.task_execution_role.arn
  task_role_arn      = aws_iam_role.task_role.arn
  network_mode       = "awsvpc"

  cpu    = var.cpu
  memory = var.memory

  requires_compatibilities = ["FARGATE"]

  tags = module.labels.tags

  container_definitions = jsonencode(local.container_definitions)
}

# ECS Service registers itself with an ALB target group
resource "aws_ecs_service" "service" {
  name    = module.labels.namespace
  cluster = var.ecs_cluster_id

  task_definition = format("%s:%s", aws_ecs_task_definition.task.family, aws_ecs_task_definition.task.revision)

  desired_count                      = var.instance_count
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50

  network_configuration {
    subnets          = var.vpc_subnet_ids
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.load_balancer.target_group_arn
    container_name   = var.load_balancer.container_name
    container_port   = var.load_balancer.container_port
  }

  # see https://stackoverflow.com/questions/53971873/the-target-group-does-not-have-an-associated-load-balancer
  depends_on = [
    null_resource.listeners
  ]
}

resource "null_resource" "listeners" {
  triggers = {
    listeners = join(",", var.load_balancer.listener_arns)
  }
}
