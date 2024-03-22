terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31.0"
    }
  }

  required_version = ">= 1.7.0"
}


terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform.huge.head.li.2023"
    dynamodb_table = "terraform-state-lock"
    key            = "rds-postgres-iam-proxy-example"
    region         = "us-east-1"
  }
}

# aws_caller_identity
data "aws_caller_identity" "current" {}
