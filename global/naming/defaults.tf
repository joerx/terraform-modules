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
