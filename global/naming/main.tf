locals {
  # default for optional values, will be stripped
  nil           = "~"
  replace_chars = "/[^A-Za-z0-9]+/"

  # Name, using 'service' as alias
  name = coalesce(var.name, var.service, var.context.name)

  # direct vars take prio over parent context
  context = {
    # Mandatory attributes, if both local parent values are empty, coalesce will fail
    name  = local.name
    env   = lower(replace(coalesce(var.env, var.context.env), local.replace_chars, "-"))
    owner = lower(replace(coalesce(var.owner, var.context.owner), local.replace_chars, "-"))
    slug  = lower(replace(coalesce(var.slug, local.name, var.context.slug), local.replace_chars, "-"))

    # Coalesce() can't return null or an empty string, so we need to perform this little stunt
    tier      = replace(coalesce(var.tier, var.context.tier, local.nil), local.nil, "")
    service   = replace(coalesce(var.service, var.context.service, local.nil), local.nil, "")
    component = replace(coalesce(var.component, var.context.component, local.nil), local.nil, "")

    # Tags are merged, not overridden
    tags = merge(var.tags, var.context.tags)
  }

  parts = compact([local.context.env, local.context.slug, local.context.component])

  # Namespace is the main identifier for resources
  namespace = join("-", local.parts)

  # Path for directory like structures, follows the same pattern
  path = join("/", local.parts)

  # Standard tags based on context labels
  standard_tags = {
    Terraform   = true
    Name        = local.namespace
    Environment = local.context.env
    Service     = local.context.service
    Owner       = local.context.owner
    Tier        = local.context.tier
  }

  # Merge with var.tags, the latter take precedence
  all_tags = merge(local.standard_tags, local.context.tags)

  # Remove empty string values
  tags = { for k, v in local.all_tags : k => v if v != "" }
}
