locals {
  bucket_name = "example-bucket-huge-head-li"
}

resource "aws_s3_bucket" "s3" {
  bucket        = local.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "s3" {
  bucket                  = aws_s3_bucket.s3.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "s3" {
  bucket = aws_s3_bucket.s3.bucket

  rule {
    id = "expires"

    expiration {
      days = 1
    }

    status = "Enabled"
  }
}
