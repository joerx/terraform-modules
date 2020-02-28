module "context1" {
  source  = "../"
  env     = "staging"
  service = "backend"
  tier    = "service"
  owner   = "backend-dev"

  tags = {
    Backup = true
  }
}

output "context1" {
  value = module.context1
}


# results are identical
module "context1_1" {
  source  = "../"
  context = module.context1.context
}

output "context1_1" {
  value = module.context1_2
}


# override "tier"
module "context1_2" {
  source  = "../"
  context = module.context1.context
  tier    = "storage"
}

output "context1_2" {
  value = module.context1_2
}


# inherit "tier", tags are merged
module "context1_2_1" {
  source  = "../"
  context = module.context1_2.context
  tier    = "storage"

  tags = {
    StorageClass = "aws-gp2"
  }
}

output "context1_2_1" {
  value = module.context1_2_1
}


# inherit from context1, override slug
module "context1_3" {
  source  = "../"
  context = module.context1.context
  slug    = "be"
}

output "context1_3" {
  value = module.context1_3
}

# inherits slug from context1_3
module "context1_3_1" {
  source  = "../"
  context = module.context1_2.context
  slug    = "be"
}

output "context1_3_1" {
  value = module.context1_3_1
}
