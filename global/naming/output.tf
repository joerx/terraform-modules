output "namespace" {
  description = "Namespace to name resources with"
  value       = local.namespace
}

output "path" {
  description = "Path prefix for path like structures, e.g. file system, SSM, etc. without leading or trailing slash"
  value       = local.path
}

output "iam_path" {
  description = "Path prefix for IAM resources, with leading and trailing slash"
  value       = local.iam_path
}

output "tags" {
  description = "Tags to apply to resources"
  value       = local.tags
}

output "env" {
  description = "Service environment, i.e. stage, e.g. dev, staging, production"
  value       = var.env
}

output "service" {
  description = "Service name"
  value       = var.service
}

output "slug" {
  description = "Service slug"
  value       = local.slug
}

output "tier" {
  description = "Service tier"
  value       = var.tier
}

output "owner" {
  description = "Team that owns the service, e.g. dba, frontend-devs, etc."
  value       = var.owner
}
