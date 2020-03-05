locals {
  vpc_id = module.vpc.vpc_id

  route_tables = {
    public   = module.vpc.public_route_table_ids
    private  = module.vpc.private_route_table_ids
    database = module.vpc.database_route_table_ids
  }

  subnets = {
    public   = module.vpc.public_subnets
    private  = module.vpc.private_subnets
    database = module.vpc.database_subnets
  }

  route_table_ids = flatten(values(local.route_tables))
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> v2.0"

  name = module.naming.namespace
  tags = module.naming.tags

  cidr = var.vpc_cidr

  # Save some EIPs (and money)
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_vpn_gateway = false

  enable_s3_endpoint = true

  azs = [
    data.aws_availability_zones.available.names[0],
    data.aws_availability_zones.available.names[1],
    data.aws_availability_zones.available.names[2],
  ]

  database_subnets = [
    cidrsubnet(local.vpc_cidr, 8, 1),
    cidrsubnet(local.vpc_cidr, 8, 2),
    cidrsubnet(local.vpc_cidr, 8, 3),
  ]

  database_subnet_tags = {
    Zone = "database"
  }

  database_route_table_tags = {
    Zone = "database"
  }

  private_subnets = [
    cidrsubnet(local.vpc_cidr, 8, 11),
    cidrsubnet(local.vpc_cidr, 8, 12),
    cidrsubnet(local.vpc_cidr, 8, 13),
  ]

  private_subnet_tags = {
    Zone = "private"
  }

  private_route_table_tags = {
    Zone = "private"
  }

  public_subnets = [
    cidrsubnet(local.vpc_cidr, 8, 21),
    cidrsubnet(local.vpc_cidr, 8, 22),
    cidrsubnet(local.vpc_cidr, 8, 23),
  ]

  public_subnet_tags = {
    Zone = "public"
  }

  public_route_table_tags = {
    Zone = "public"
  }
}
