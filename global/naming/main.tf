locals {
  slug = var.slug != null ? var.slug : lower(replace(var.service, "/[^A-Za-z0-9]+/", "-"))

  namespace = join("-", compact([var.env, local.slug, var.component]))
  path      = join("/", compact([var.env, "service", local.slug, var.component]))
  iam_path  = format("/%s/", local.path)

  default_tags = {
    Terraform   = true
    Name        = local.namespace
    Environment = var.env
    Service     = var.service
    Owner       = var.owner
    Tier        = var.tier
  }

  tags = merge(local.default_tags, var.tags)
}
