resource "aws_security_group" "ecs" {
  name        = "${module.labels.namespace}-ecs"
  description = "Security group for ECS service ${module.labels.namespace}"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ecs_ingress" {
  type              = "ingress"
  from_port         = var.load_balancer.container_port
  to_port           = var.load_balancer.container_port
  protocol          = "tcp"
  cidr_blocks       = var.ingress_cidr_blocks
  security_group_id = aws_security_group.ecs.id
}

resource "aws_security_group_rule" "ecs_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs.id
}
