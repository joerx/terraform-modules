variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "naming" {
  type = any
}

variable "create_hopper" {
  type    = bool
  default = false
}
