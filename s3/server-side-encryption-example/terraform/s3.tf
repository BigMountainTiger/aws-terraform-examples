locals {
  bucket_name = "s3-server-side-encryption-example-huge-head-li"
}

resource "aws_s3_bucket" "s3" {
  bucket        = local.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3" {
  bucket = aws_s3_bucket.s3.id
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
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
