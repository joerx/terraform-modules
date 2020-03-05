locals {
  keyfile_output_path = var.keyfile_output_path != null ? var.keyfile_output_path : "${path.module}/out/key_rsa.pem"

  instance_id = var.enabled ? aws_instance.hopper[0].id : null
  public_ip   = var.enabled ? aws_instance.hopper[0].public_ip : null
  ssh_key     = var.enabled ? local_file.admin_private_key[0].filename : null
  login       = var.enabled ? format("ssh -i %s %s@%s", local.ssh_key, var.ami.user, local.public_ip) : null
}

module "naming" {
  # source    = "http://tfmodules.lolcatz.de/global/naming-v1.2.tar.gz"
  source    = "/Users/joerg.henning/Devel/joerx/terraform-modules/global/naming"
  context   = var.naming
  component = "hopper"
}

# AMI Lookup
data "aws_ami" "a" {
  count = var.enabled ? 1 : 0

  most_recent = true

  filter {
    name   = "name"
    values = [var.ami.name]
  }

  filter {
    name   = "virtualization-type"
    values = [var.ami.virt_type]
  }

  owners = [var.ami.owner]
}

# Dedicated SSH key
resource "tls_private_key" "admin" {
  count     = var.enabled ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "admin_private_key" {
  count                = var.enabled ? 1 : 0
  sensitive_content    = tls_private_key.admin[count.index].private_key_pem
  filename             = local.keyfile_output_path
  file_permission      = "0400"
  directory_permission = "0755"
}

resource "aws_key_pair" "admin" {
  count      = var.enabled ? 1 : 0
  key_name   = module.naming.namespace
  public_key = tls_private_key.admin[count.index].public_key_openssh
  tags       = module.naming.tags
}

resource "random_shuffle" "subnet" {
  count = var.enabled ? 1 : 0
  input = var.subnet_ids
}

resource "aws_instance" "hopper" {
  count         = var.enabled ? 1 : 0
  ami           = data.aws_ami.a[count.index].id
  instance_type = var.instance_type
  key_name      = aws_key_pair.admin[count.index].key_name

  subnet_id                   = element(random_shuffle.subnet[count.index].result, 1)
  vpc_security_group_ids      = [aws_security_group.sg[count.index].id]
  associate_public_ip_address = true

  lifecycle {
    ignore_changes = [ami]
  }

  tags = module.naming.tags
}
