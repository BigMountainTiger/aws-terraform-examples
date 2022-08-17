provider "aws" {
  version = "~> 3.37"
  region  = "us-east-1"
}

resource "aws_s3_bucket" "terraform_s3" {
  bucket = "terraform-version-test.huge.head.li"
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform.huge.head.li"
    dynamodb_table = "terraform-state-lock"
    key            = "old-version-terraform-example"
    region         = "us-east-1"
  }
}
