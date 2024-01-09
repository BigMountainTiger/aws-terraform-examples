locals {
  region = "us-east-1"
}

provider "aws" {
  region = local.region

  default_tags {
    tags = {
      Project     = "secret manager example"
      Subproject = "simple example"
    }
  }
}
