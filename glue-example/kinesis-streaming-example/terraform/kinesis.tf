locals {
  stream_name     = "aws-glue-kinesis-test"
  stream_app_name = "kinesis-stream-test"
}

resource "aws_kinesis_stream" "test_stream" {
  name             = local.stream_name
  shard_count      = 1
  retention_period = 24

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}

resource "aws_dynamodb_table" "streaming_dynamo_table" {
  name         = local.stream_app_name
  hash_key     = "leaseKey"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "leaseKey"
    type = "S"
  }
}

output "stream_name" {
  value = local.stream_name
}

output "stream_app_name" {
  value = local.stream_app_name
}
