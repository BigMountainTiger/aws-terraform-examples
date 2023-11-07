# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream.html

locals {
  s3_firehose_name             = "kinesis-firehose-cloudwatch-metrics-s3"
  http_firehose_name           = "kinesis-firehose-cloudwatch-metrics-http"
  cloudwatch_metrics_namespace = "custom-metrics-example-namespace"
}

# S3 target
resource "aws_kinesis_firehose_delivery_stream" "s3" {
  name        = local.s3_firehose_name
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.s3_role.arn
    bucket_arn = aws_s3_bucket.kinesis_example_s3.arn

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

resource "aws_cloudwatch_metric_stream" "cloudwatch_metric_stream_s3" {
  name          = "my-metric-stream-s3"
  role_arn      = aws_iam_role.cloudwatch_to_firehose_role.arn
  firehose_arn  = aws_kinesis_firehose_delivery_stream.s3.arn
  output_format = "json"

  include_filter {
    namespace = local.cloudwatch_metrics_namespace
  }
}

# HTTP target
resource "aws_kinesis_firehose_delivery_stream" "http" {
  name        = local.http_firehose_name
  destination = "http_endpoint"

  http_endpoint_configuration {
    url            = aws_api_gateway_stage.gateway_stage.invoke_url
    name           = "test_endpoint"
    role_arn       = aws_iam_role.s3_role.arn
    s3_backup_mode = "FailedDataOnly"

    buffering_size     = 1
    buffering_interval = 60

    request_configuration {
      
      common_attributes {
        name  = "example_attribute_1"
        value = "example_value_1"
      }

      common_attributes {
        name  = "example_attribute_2"
        value = "example_value_2"
      }
    }

    s3_configuration {
      bucket_arn = aws_s3_bucket.kinesis_example_s3.arn
      role_arn   = aws_iam_role.s3_role.arn
    }
  }
}

resource "aws_cloudwatch_metric_stream" "cloudwatch_metric_stream_http" {
  name          = "my-metric-stream-http"
  role_arn      = aws_iam_role.cloudwatch_to_firehose_role.arn
  firehose_arn  = aws_kinesis_firehose_delivery_stream.http.arn
  output_format = "json"

  include_filter {
    namespace = local.cloudwatch_metrics_namespace
  }
}
