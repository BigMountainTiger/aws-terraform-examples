provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform.huge.head.li.2023"
    dynamodb_table = "terraform-state-lock"
    key            = "athena-example-json-example"
    region         = "us-east-1"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.74.0"
    }
  }

  required_version = ">= 1.9.0"
}