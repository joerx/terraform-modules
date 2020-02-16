variable "local_vpc" {
  description = "Routing info for local (requester) VPC"

  type = object({
    id      = string
    cidr    = string
    rtb_ids = list(string)
  })
  default = null
}

variable "peer_vpc" {
  description = "Routing info for peer (accepter) VPC"

  type = object({
    id      = string
    cidr    = string
    rtb_ids = list(string)
  })
  default = null
}

variable "local_vpc_name" {
  description = "If set, routing info for local will be automatically looked up via Name tag. Ignored if `local_vpc` != null"

  type    = string
  default = null
}

variable "peer_vpc_name" {
  description = "If set, routing info for peer will be automatically looked up via Name. Ignored if `peer_vpc` != null"

  type    = string
  default = null
}

variable "local_rtb_filters" {
  description = "Narrow down RTBs that receive pcx routes. By default, all RTBs will be used. Ignored if `local_vpc` is != null"

  type = list(object({
    name   = string
    values = list(string)
  }))

  default = []
}

variable "peer_rtb_filters" {
  description = "Narrow down RTBs that receive pcx routes. By default, all RTBs will be used. Ignored if `peer_vpc` is != null"

  type = list(object({
    name   = string
    values = list(string)
  }))

  default = []
}

