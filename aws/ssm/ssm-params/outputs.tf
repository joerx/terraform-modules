output "arns" {
  value = concat(local.param_arns, local.secret_arns)
}

output "ssm_namespace" {
  description = "Common namespace prefix for all SSM params in this module"
  value       = local.ssm_namespace
}

output "kms_key_id" {
  value = aws_kms_key.k.key_id
}

output "kms_key_arn" {
  value = aws_kms_key.k.arn
}

output "kms_key_alias" {
  value = local.kms_alias
}
