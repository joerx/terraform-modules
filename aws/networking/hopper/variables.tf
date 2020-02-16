variable "env" {
  type = string
}

variable "namespace" {
  type = string
}

variable "ami" {
  type = object({
    user      = string
    name      = string
    virt_type = string
    owner     = string
  })

  default = {
    user      = "ec2-user"
    name      = "amzn2-ami-hvm-2.0.*.0-x86_64-gp2"
    virt_type = "hvm"
    owner     = "137112412989"
  }
}

variable "instance_type" {
  default = "t2.micro"
}

variable "keyfile_output_path" {
  description = "File system path to write generate SSH key to"
  default     = null
}

variable "ssh_ip4_ingress_cidrs" {
  default = ["0.0.0.0/0"]
}

variable "ssh_ip6_ingress_cidrs" {
  default = ["::/0"]
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}
