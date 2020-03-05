module "parent_label" {
  source = "../"
  env    = "staging"
  name   = "backend"
  tier   = "service"
  owner  = "backend-dev"

  tags = {
    Backup = true
  }
}

output "l1_parent_label" {
  value = module.parent_label
}

# results are identical
module "child_label_1" {
  source  = "../"
  context = module.parent_label.context
}

output "l2_child_label_1" {
  value = module.child_label_1
}

# override "tier"
module "storage_label" {
  source  = "../"
  context = module.parent_label.context
  tier    = "storage"
}

output "l3_storage_label" {
  value = module.storage_label
}

# inherit "tier", tags are merged
module "storage_class_label" {
  source  = "../"
  context = module.storage_label.context
  tier    = "storage"

  tags = {
    StorageClass = "aws-gp2"
  }
}

output "l4_storage_class_label" {
  value = module.storage_class_label
}

# using service instead of name
module "service_label" {
  source  = "../"
  context = module.parent_label.context
  service = "FooService"
}

output "l5_service_label" {
  value = module.service_label
}

# using service, but overriding slug
module "service_label_slug" {
  source  = "../"
  context = module.service_label.context
  slug    = "foo-service"
}

output "l6_service_label_slug" {
  value = module.service_label_slug
}
