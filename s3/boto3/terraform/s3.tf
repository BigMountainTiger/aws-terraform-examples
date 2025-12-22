locals {
  bucket_name = "s3-boto3-example-huge-head-li"
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

output "s3_name" {
  value = aws_s3_bucket.s3.id
}
