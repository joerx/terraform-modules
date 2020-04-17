# IAM Trust Policy
# ================
# Defines who can assume an IAM role. In this case it is the ECS service for all the roles we create

data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# IAM Task Execution Role
# =======================
# This role is for the ECS engine itself, NOT for the applications inside the container
# Needs permissions to pull docker images, create/write log streams, read secrets etc.

resource "aws_iam_role" "task_execution_role" {
  name               = "${module.labels.namespace}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
  tags               = merge(module.labels.tags, { Role : "ecs-task-execution-role" })
  path               = "/${module.labels.path}/"
}


# Includes ECR image pull and cloudwatch log events
resource "aws_iam_role_policy_attachment" "base_execution_policy" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "docker_secret" {
  count = length(local.docker_secret_arns) > 0 ? 1 : 0

  statement {
    sid       = "AllowGetSecretValue"
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = local.docker_secret_arns
  }

  statement {
    sid       = "AllowKMSDecrypt"
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = local.docker_kms_key_arns
  }
}

resource "aws_iam_policy" "docker_login" {
  count       = length(local.docker_secret_arns) > 0 ? 1 : 0
  name        = "${module.labels.namespace}-docker-login-read"
  policy      = data.aws_iam_policy_document.docker_secret[count.index].json
  path        = "/${module.labels.path}/"
  description = "Access to docker login secret for ${module.labels.namespace}"
}

resource "aws_iam_role_policy_attachment" "docker_login_read_policy" {
  count      = length(local.docker_secret_arns) > 0 ? 1 : 0
  role       = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.docker_login[count.index].arn
}

# IAM Task Role
# =============
# This is the role assumed by the container itself.
# It contains the permissions needed by the applications running inside the container

resource "aws_iam_role" "task_role" {
  name               = "${module.labels.namespace}-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
  tags               = merge(module.labels.tags, { Role : "ecs-task-role" })
  path               = "/${module.labels.path}/"
}

resource "aws_iam_role_policy_attachment" "task_role" {
  role       = aws_iam_role.task_role.name
  policy_arn = aws_iam_policy.task_role_policy.arn
}

data "aws_iam_policy_document" "task_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "firehose:PutRecordBatch"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "task_role_policy" {
  name        = "${module.labels.namespace}-task-role-policy"
  policy      = data.aws_iam_policy_document.task_role_policy.json
  path        = "/${module.labels.path}/"
  description = "ECS task role for ${module.labels.namespace}"
}
