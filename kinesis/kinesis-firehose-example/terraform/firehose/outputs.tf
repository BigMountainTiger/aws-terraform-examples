output "bucket_name" {
  value = local.bucket_name
}

output "firehose_name" {
  value = aws_kinesis_firehose_delivery_stream.s3.name
}
