terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  region                   = "us-east-1"
}

resource "aws_s3_bucket" "terraform_s3" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "terraform_s3_block_access" {
  bucket                  = aws_s3_bucket.terraform_s3.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "terraform_s3_versioning" {
  bucket = aws_s3_bucket.terraform_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.terraform_s3.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name         = var.dynamo_name
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}
