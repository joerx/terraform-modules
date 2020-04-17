variable "labels" {
  type = any
}

variable "external_ingress_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "external_egress_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "vpc_id" {
  type = string
}

variable "vpc_subnet_ids" {
  type = list(string)
}

variable "create_http_listener" {
  type    = bool
  default = false
}

variable "create_https_listener" {
  type    = bool
  default = true
}

variable "acm_certificate_arn" {
  description = "Must be provided if create_https_listener = true"
  type        = string
  default     = null
}

variable "internal" {
  type    = bool
  default = false
}

variable "http_port" {
  type    = number
  default = 80
}

variable "https_port" {
  type    = number
  default = 443
}

variable "target_group" {
  description = "Settings for the LB target group to be created"

  type = object({
    proto = string
    port  = number
    type  = string
  })
}
