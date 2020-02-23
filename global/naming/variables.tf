variable "env" {
  description = "Service environment, i.e. stage, e.g. dev, staging, production"
  type        = string
}

variable "service" {
  description = "Service name"
  type        = string
}

variable "owner" {
  description = "Team that owns the service, e.g. dba, frontend-devs, etc."
  type        = string
}
