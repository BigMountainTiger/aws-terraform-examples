provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    encrypt      = true
    bucket       = "terraform.huge.head.li.2023"
    use_lockfile = true
    key          = "lambda-examples-update-function-code"
    region       = "us-east-1"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.51.0"
    }
  }

  required_version = ">= 1.5.0"
}

