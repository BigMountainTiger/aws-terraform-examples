provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    encrypt      = true
    bucket       = "terraform.huge.head.li.2023"
    use_lockfile = true
    key          = "vpc-example"
    region       = "us-east-1"
  }
}
