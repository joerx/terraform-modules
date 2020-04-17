module "labels" {
  source    = "http://tfmodules.lolcatz.de/global/naming-v1.3.tar.gz"
  context   = var.labels
  component = "lb"
}

resource "aws_security_group" "lb" {
  name        = module.labels.namespace
  description = "Security group for LB ${module.labels.namespace}"
  vpc_id      = var.vpc_id
  tags        = module.labels.tags
}

resource "aws_security_group_rule" "lb_http_ingress" {
  count             = var.create_http_listener ? 1 : 0
  type              = "ingress"
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = "tcp"
  cidr_blocks       = var.external_ingress_cidrs
  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "lb_https_ingress" {
  count             = var.create_https_listener ? 1 : 0
  type              = "ingress"
  from_port         = var.https_port
  to_port           = var.https_port
  protocol          = "tcp"
  cidr_blocks       = var.external_ingress_cidrs
  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "lb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = var.external_egress_cidrs
  security_group_id = aws_security_group.lb.id
}

resource "aws_lb_target_group" "service" {
  name                 = module.labels.namespace
  tags                 = module.labels.tags
  port                 = var.target_group.port
  protocol             = var.target_group.proto
  target_type          = var.target_group.type
  vpc_id               = var.vpc_id
  deregistration_delay = 10
}

resource "aws_lb" "lb" {
  name               = module.labels.namespace
  load_balancer_type = "application"
  internal           = var.internal

  security_groups = [aws_security_group.lb.id]
  subnets         = var.vpc_subnet_ids

  enable_deletion_protection = false

  tags = module.labels.tags
}

resource "aws_lb_listener" "http" {
  count = var.create_http_listener ? 1 : 0

  load_balancer_arn = aws_lb.lb.arn
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service.arn
  }
}

resource "aws_lb_listener" "https" {
  count = var.create_https_listener ? 1 : 0

  load_balancer_arn = aws_lb.lb.arn
  port              = var.https_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  certificate_arn = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service.arn
  }
}
