locals {
  keyfile_output_path = var.keyfile_output_path != null ? var.keyfile_output_path : "${path.module}/out/key_rsa.pem"

  instance_id = aws_instance.hopper.id
  public_ip   = aws_instance.hopper.public_ip
  ssh_key     = local_file.admin_private_key.filename
  login       = format("ssh -i %s %s@%s", local.ssh_key, var.ami.user, local.public_ip)
}

module "naming" {
  source  = "git@github.com:/joerx/terraform-modules//global/naming?ref=aaf63f8"
  env     = var.env
  service = var.service
  owner   = var.owner
  tier    = var.tier

  tags = {
    Name = var.name
  }
}

# AMI Lookup
data "aws_ami" "a" {
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
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "admin_private_key" {
  sensitive_content    = tls_private_key.admin.private_key_pem
  filename             = local.keyfile_output_path
  file_permission      = "0400"
  directory_permission = "0755"
}

resource "aws_key_pair" "admin" {
  key_name   = module.naming.namespace
  public_key = tls_private_key.admin.public_key_openssh
  tags       = module.naming.tags
}

resource "random_shuffle" "subnet" {
  input = var.subnet_ids
}

resource "aws_instance" "hopper" {
  ami           = data.aws_ami.a.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.admin.key_name

  subnet_id                   = element(random_shuffle.subnet.result, 1)
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = true

  lifecycle {
    ignore_changes = [ami]
  }

  tags = module.naming.tags
}
