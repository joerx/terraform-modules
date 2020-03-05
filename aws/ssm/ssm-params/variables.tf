variable "naming" {
  type = any
}

variable "component" {
  type    = string
  default = null
}

variable "secrets" {
  type    = map(string)
  default = {}
}

variable "params" {
  type    = map(string)
  default = {}
}
