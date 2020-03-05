variable "env" {
  description = "Service environment, i.e. stage, e.g. dev, staging, production"
  type        = string
  default     = null
}

variable "name" {
  description = "Component or service name"
  type        = string
  default     = null
}

variable "service" {
  description = "Service name. Alias for `name`"
  type        = string
  default     = null
}

variable "owner" {
  description = "Team that owns the service, e.g. dba, frontend-devs, etc."
  type        = string
  default     = null
}

variable "slug" {
  description = "Optional short name, if not set, will be generated based on `service`"
  type        = string
  default     = null
}

variable "tier" {
  description = "Service tier, e.g. storage, networking, etc."
  type        = string
  default     = null
}

variable "tags" {
  description = "Extra tags, will be merged with default tags, taking precendence"
  type        = map(string)
  default     = {}
}

variable "component" {
  description = "Additional component name to further segment the namespace"
  type        = string
  default     = null
}

variable "context" {
  type = object({
    env       = string
    name      = string
    owner     = string
    service   = string
    slug      = string
    tier      = string
    component = string
    tags      = map(string)
  })

  default = {
    env       = null
    name      = null
    service   = null
    slug      = null
    tier      = null
    owner     = null
    component = null
    tags      = {}
  }
}

variable "namespace" {
  description = "Override the default namespace"
  default     = null
}
