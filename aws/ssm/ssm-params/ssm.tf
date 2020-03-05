# Note: we could use AWS SecretsManager, but they cost 0.40$ per month, while SSM parameters are free
# SSM is lacking features like auto-rotation, but for this demo env it doesn't really matter

locals {
  param_arns    = [for p in aws_ssm_parameter.params : p.arn]
  secret_arns   = [for p in aws_ssm_parameter.secrets : p.arn]
  ssm_namespace = module.naming.path
  kms_alias     = format("alias/%s", module.naming.path)
}

resource "aws_kms_key" "k" {
  description             = "KMS key to encrypt secrets for ${module.naming.namespace}"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "a" {
  name          = local.kms_alias
  target_key_id = aws_kms_key.k.key_id
}

resource "aws_ssm_parameter" "secrets" {
  for_each    = var.secrets
  name        = format("/%s/%s", local.ssm_namespace, each.key)
  description = "Secret param \"${each.key}\" for ${module.naming.namespace}"
  type        = "SecureString"
  value       = each.value
  key_id      = aws_kms_key.k.key_id
  tags        = merge(module.naming.tags, { Name : each.key })
}

resource "aws_ssm_parameter" "params" {
  for_each    = var.params
  name        = format("/%s/%s", local.ssm_namespace, each.key)
  description = "Param \"${each.key}\" for ${module.naming.namespace}"
  type        = "String"
  value       = each.value
  tags        = merge(module.naming.tags, { Name : each.key })
}

