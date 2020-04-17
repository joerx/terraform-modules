variable "instance_count" {
  default = 1
}

variable "ecs_cluster_id" {
  type = string
}

variable "containers" {
  default = null
  type    = any
}

variable "cpu" {
  type    = number
  default = 256
}

variable "memory" {
  type    = number
  default = 512
}

variable "labels" {
  type = any
}

variable "vpc_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "ingress_cidr_blocks" {
  type = list(string)
}

variable "load_balancer" {
  type = object({
    target_group_arn = string
    listener_arns    = list(string)
    container_name   = string
    container_port   = number
  })
}
