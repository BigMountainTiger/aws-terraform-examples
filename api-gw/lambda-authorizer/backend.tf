provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform.huge.head.li.2023"
    dynamodb_table = "terraform-state-lock"
    key            = "api-gw-lambda-authorizer"
    region         = "us-east-1"
  }
}
