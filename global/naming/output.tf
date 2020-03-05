output "namespace" {
  description = "Namespace to name resources with"
  value       = local.namespace
}

output "path" {
  description = "Path prefix for path like structures, e.g. file system, SSM, etc. without leading or trailing slash"
  value       = local.path
}

output "tags" {
  description = "Tags to apply to resources"
  value       = local.tags
}

output "env" {
  description = "Service environment, i.e. stage, e.g. dev, staging, production"
  value       = local.context.env
}

output "service" {
  description = "Service name"
  value       = local.context.service
}

output "slug" {
  description = "Service slug"
  value       = local.context.slug
}

output "tier" {
  description = "Service tier"
  value       = local.context.tier
}

output "owner" {
  description = "Team that owns the service, e.g. dba, frontend-devs, etc."
  value       = local.context.owner
}

output "context" {
  description = "Export naming to be passed as input to another naming module"
  value       = local.context
}
