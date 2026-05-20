# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream.html

locals {
  firehose_name   = "kinesis-firehose-kinesis-example-huge-head-li"
}

resource "aws_kinesis_firehose_delivery_stream" "s3" {
  name        = local.firehose_name
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.s3_role.arn
    bucket_arn = data.aws_s3_bucket.kinesis_example_s3.arn

    buffering_size     = 1
    buffering_interval = 60

    prefix              = "data/"
    error_output_prefix = "errors/"

    cloudwatch_logging_options {
      enabled = true

      log_group_name  = aws_cloudwatch_log_group.log.name
      log_stream_name = aws_cloudwatch_log_stream.log.name
    }
  }
}
