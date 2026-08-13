locals {
  bucket_name               = "a-basic-s3-bucket-huge-head-li"
  retention_noncurrent_days = 1
  retention_days            = 1
  force_destroy             = true
}

# s3 resouces:
# 1. bucket
# 2. server side encryption
# 2. bucket versioning
# 4. block public access
# 5. life cycle

resource "aws_s3_bucket" "s3" {
  bucket        = local.bucket_name
  force_destroy = local.force_destroy

  tags = {
    "name" = local.bucket_name
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3" {
  bucket = aws_s3_bucket.s3.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_versioning" "s3" {
  bucket = aws_s3_bucket.s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "s3" {
  bucket                  = aws_s3_bucket.s3.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "s3" {
  bucket = aws_s3_bucket.s3.id

  rule {
    id     = "retention-policy"
    status = "Enabled"
    filter {
      prefix = ""
    }

    noncurrent_version_expiration {
      noncurrent_days = local.retention_noncurrent_days
    }

    expiration {
      days = local.retention_days
    }
  }

  rule {
    id     = "delete-expired-markers"
    status = "Enabled"
    filter {
      prefix = ""
    }

    expiration {
      expired_object_delete_marker = true
    }
  }
}
