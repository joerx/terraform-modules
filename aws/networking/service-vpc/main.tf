locals {
  vpc_cidr = var.vpc_cidr
}

module "naming" {
  source  = "http://tfmodules.lolcatz.de/global/naming-v1.3.tar.gz"
  context = var.naming
  tier    = "networking"
}

module "naming_hopper" {
  source    = "http://tfmodules.lolcatz.de/global/naming-v1.3.tar.gz"
  context   = module.naming.context
  component = "hopper"
}

data "aws_availability_zones" "available" {}
