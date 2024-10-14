# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream.html


resource "aws_kinesis_firehose_delivery_stream" "s3" {
  name        = "kinesis-firehose-eventbridge-to-s3"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose.arn
    bucket_arn = aws_s3_bucket.s3.arn

    # buffering_size = M, buffering_interval = second
    buffering_size     = 1
    buffering_interval = 60

    # prefix              = "data/"
    # error_output_prefix = "errors/"

    # It is possible to configure the destinaton folder names
    # https://docs.aws.amazon.com/firehose/latest/dev/s3-prefixes.html
    prefix              = "data/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"
    error_output_prefix = "errors/!{firehose:error-output-type}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"

    processing_configuration {
      enabled = "true"

      # https://docs.aws.amazon.com/firehose/latest/dev/data-transformation.html
      # Firehose timeouts if Lambda is unable to finish the processing 
      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${aws_lambda_function.lambda.arn}:$LATEST"
        }
      }
    }

    cloudwatch_logging_options {
      enabled = true

      log_group_name  = aws_cloudwatch_log_group.log.name
      log_stream_name = aws_cloudwatch_log_stream.log.name
    }
  }
}
