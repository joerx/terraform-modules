output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = local.vpc_cidr
}

output "vpc_tags" {
  value = module.naming.tags
}

output "hopper" {
  value = module.hopper
}
