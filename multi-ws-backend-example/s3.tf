resource "aws_s3_bucket" "terraform_s3" {
  bucket = local.bucket_name
}

resource "aws_s3_bucket_public_access_block" "mybucket_block_access" {
  bucket                  = aws_s3_bucket.terraform_s3.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}