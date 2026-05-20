terraform {
  backend "s3" {
    encrypt      = true
    bucket       = "terraform.huge.head.li.2023"
    use_lockfile = true
    region       = "us-east-1"
  }
}

provider "aws" {
  region = local.region
}

data "template_file" "region" {
  template = "$${region}"

  vars = {
    region = terraform.workspace
  }
}
