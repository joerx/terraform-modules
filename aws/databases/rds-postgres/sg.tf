resource "aws_security_group" "default" {
  description = "Security group for DB ${module.naming.namespace}"
  name        = "${module.naming.namespace}-db"
  vpc_id      = local.vpc_id
  tags        = local.tags
}

resource "aws_security_group_rule" "allow_vpc_ingress" {
  description       = "Allow local ingress from VPC ${var.vpc_name}"
  protocol          = "tcp"
  type              = "ingress"
  from_port         = local.db_port
  to_port           = local.db_port
  cidr_blocks       = local.vpc_cidr_blocks
  security_group_id = aws_security_group.default.id
}
