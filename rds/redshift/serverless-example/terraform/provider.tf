terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.24.0"
    }
  }

  required_version = ">= 1.5.0"
}

locals {
  region = "us-east-1"
}

provider "aws" {
  region = local.region
}
