terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.12.0"
    }
  }

  required_version = ">= 1.12.0"
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform.huge.head.li.2023"
    dynamodb_table = "terraform-state-lock"
    key            = "glue-example-iceberg-example"
    region         = "us-east-1"
  }
}

