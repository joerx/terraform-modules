variable "naming" {
  type = any
}

variable "engine_version" {
  type = string
}

variable "instance_type" {
  default = "db.t2.micro"
}

variable "storage" {
  default = 10
}

variable "storage_type" {
  default = "gp2"
}

variable "db_user" {
  default = "postgres"
}

variable "db_name" {
  default = "postgres"
}

variable "vpc_name" {
  type = string
}

variable "db_subnet_group_name" {
  description = "Name of the db subnet group, if null, assuming the same as the vpc name"
  default     = null
}

variable "port" {
  default = 5432
}

variable "backup_enabled" {
  default = false
}

variable "apply_immediately" {
  default = true
}

variable "skip_final_snapshot" {
  default = false
}

variable "db_params" {
  type = list(object({
    name         = string
    value        = string
    apply_method = string
  }))

  default = []
}

variable "extra_cidr_blocks" {
  description = "Additional CIDR blocks to allow ingress in the db port from"
  type        = list(string)
  default     = []
}
