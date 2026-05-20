provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.12.0"
    }
  }

  required_version = ">= 1.12.0"

  backend "s3" {
    bucket       = "terraform.huge.head.li.2023"
    encrypt      = true
    use_lockfile = true
    key          = "ecs-examples-ecr-example"
    region       = "us-east-1"
  }
}
