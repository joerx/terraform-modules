locals {
  db_family = local.instance_family_map[var.engine_version]
  db_engine = "postgres"

  db_engine_version   = var.engine_version
  db_instance_type    = var.instance_type
  db_port             = var.port
  db_backup_enabled   = var.backup_enabled
  db_params           = var.db_params
  apply_immediately   = var.apply_immediately
  skip_final_snapshot = var.skip_final_snapshot

  db_storage      = var.storage
  db_storage_type = var.storage_type

  db_user = var.db_user
  db_name = var.db_name

  vpc_id               = data.aws_vpc.selected.id
  vpc_cidr_blocks      = concat([data.aws_vpc.selected.cidr_block], var.extra_cidr_blocks)
  db_subnet_group_name = var.db_subnet_group_name != null ? var.db_subnet_group_name : var.vpc_name

  tags = module.naming.tags
}

module "naming" {
  source  = "http://tfmodules.lolcatz.de/global/naming-v1.2.tar.gz"
  context = var.naming
}

resource "random_string" "password" {
  length  = 20
  special = false
  number  = true
}

resource "aws_db_parameter_group" "default" {
  name   = module.naming.namespace
  family = local.db_family
  tags   = local.tags

  dynamic "parameter" {
    for_each = local.db_params
    content {
      name         = parameter.name
      value        = parameter.value
      apply_method = parameter.apply_method
    }
  }
}

resource "aws_db_instance" "master" {
  identifier = module.naming.namespace

  engine               = local.db_engine
  engine_version       = local.db_engine_version
  parameter_group_name = aws_db_parameter_group.default.name
  apply_immediately    = local.apply_immediately

  instance_class    = local.db_instance_type
  storage_type      = local.db_storage_type
  allocated_storage = local.db_storage

  name     = local.db_name
  username = local.db_user
  password = random_string.password.result

  db_subnet_group_name   = local.db_subnet_group_name
  vpc_security_group_ids = [aws_security_group.default.id]

  skip_final_snapshot   = local.skip_final_snapshot
  copy_tags_to_snapshot = true

  lifecycle {
    ignore_changes = [password]
  }

  tags = merge(
    local.tags,
    { Backup : local.db_backup_enabled }
  )
}
