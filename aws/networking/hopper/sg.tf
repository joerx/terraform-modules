resource "aws_security_group" "sg" {
  count       = var.enabled ? 1 : 0
  description = "Allow traffic to hopper"
  name        = module.naming.namespace
  vpc_id      = var.vpc_id
  tags        = module.naming.tags
}

resource "aws_security_group_rule" "allow_ssh" {
  count             = var.enabled ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sg[count.index].id
}

resource "aws_security_group_rule" "egress" {
  count             = var.enabled ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.sg[count.index].id
}
