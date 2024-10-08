output "sns_topic_arn" {
  value = aws_sns_topic.example_sns_topic.arn
}

output "s3" {
  value = aws_s3_bucket.s3.bucket
}
