module "naming" {
  source    = "http://tfmodules.lolcatz.de/global/naming-v1.2.tar.gz"
  context   = var.naming
  component = var.component
}
