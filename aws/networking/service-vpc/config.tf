terraform {
  required_version = "~> 0.12.0"

  backend "s3" {
    profile = "yodo"

    bucket         = "tfstate-global-468871832330"
    key            = "sandbox/sgp/networks/sandbox-sgp/tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "tfstate-lock-global"

    kms_key_id = "alias/tfstate-global"
    encrypt    = true
  }
}

provider "aws" {
  version = "~> 2.45"
  profile = "yodo"
  region  = "ap-southeast-1"
}
