module "hopper" {
  source = "http://tfmodules.lolcatz.de/aws/networking/hopper-v1.2.tar.gz"

  enabled = var.create_hopper
  naming  = module.naming_hopper.context

  vpc_id     = local.vpc_id
  subnet_ids = local.subnets.public

  keyfile_output_path = "${path.module}/out/hopper.pem"
}
