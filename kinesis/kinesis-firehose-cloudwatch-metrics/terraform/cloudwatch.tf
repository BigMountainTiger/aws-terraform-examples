locals {
  log_group_name  = "kinesisfirehose"
  log_stream_name = "kinesis-firehose-cloudwatch-metrics"
}

resource "aws_cloudwatch_log_group" "log" {
  name = local.log_group_name

  retention_in_days = 1
}

resource "aws_cloudwatch_log_stream" "log" {
  name           = local.log_stream_name
  log_group_name = aws_cloudwatch_log_group.log.name
}
