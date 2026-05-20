resource "aws_s3_bucket" "s3" {
  bucket = "sns-example.huge.head.li"
}

resource "aws_s3_bucket_public_access_block" "s3" {
  bucket                  = aws_s3_bucket.s3.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.s3.id

  topic {
    topic_arn     = aws_sns_topic.example_sns_topic.arn
    events        = ["s3:ObjectCreated:*"]
  }
}