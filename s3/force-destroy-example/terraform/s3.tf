locals {
  bucket_name = "s3-force-destroy-example-huge-head-li"
}

resource "aws_s3_bucket" "s3" {
  bucket = local.bucket_name
}

resource "aws_s3_bucket_public_access_block" "s3" {
  bucket                  = aws_s3_bucket.s3.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# When granting the permission to another account
# The principal at the other account do not need to be aware of the existance of this account
# It just needs the same action permissions to "*" to get the access granted here
resource "aws_s3_bucket_policy" "s3" {
  bucket = aws_s3_bucket.s3.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : ["939653976686"]
        }
        "Action" : [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Resource" : [
          aws_s3_bucket.s3.arn,
          "${aws_s3_bucket.s3.arn}/*"
        ]
      }
    ]
  })
}

output "s3_name" {
  value = aws_s3_bucket.s3.id
}
