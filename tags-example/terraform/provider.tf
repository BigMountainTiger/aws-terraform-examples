locals {
  region = "us-east-1"
}

provider "aws" {
  region = local.region

  default_tags {
    tags = {
      default_tag_1 = "This is the default tag 1"
      default_tag_2 = "This is the default tag 2"
    }
  }
}
