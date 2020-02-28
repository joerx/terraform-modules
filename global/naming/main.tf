locals {
  # default for optional values, will be stripped
  nil = "~"

  nil_context = {
    env       = null
    service   = null
    slug      = null
    tier      = null
    owner     = null
    component = null
    tags      = null
  }

  parent_context = var.context != null ? var.context : local.nil_context

  default_service = coalesce(var.service, local.parent_context.service)
  default_slug    = lower(replace(local.default_service, "/[^A-Za-z0-9]+/", "-"))

  # direct vars take prio over parent context
  context = {
    # mandatory attributes, if both local parent values are empty, coalesce will fail
    service = local.default_service
    env     = coalesce(var.env, local.parent_context.env)
    owner   = coalesce(var.owner, local.parent_context.owner)
    slug    = coalesce(var.slug, local.parent_context.slug, local.default_slug)

    # coalesce can't return null or an empty string, so we need to perform this little stunt
    tier      = replace(coalesce(var.tier, local.parent_context.tier, local.nil), local.nil, "")
    component = replace(coalesce(var.component, local.parent_context.component, local.nil), local.nil, "")

    # tags are merged with parent context
    tags = merge(var.tags, coalesce(local.parent_context.tags, {}))
  }

  parts = compact([local.context.env, local.context.slug, local.context.component])

  namespace = join("-", local.parts)
  path      = join("/", local.parts)
  iam_path  = format("/%s/", local.path)

  default_tags = {
    Terraform   = true
    Name        = local.namespace
    Environment = local.context.env
    Service     = local.context.service
    Owner       = local.context.owner
    Tier        = local.context.tier
  }

  tags = merge(local.default_tags, local.context.tags)
}
