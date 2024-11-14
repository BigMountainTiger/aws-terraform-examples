resource "aws_athena_workgroup" "json_example" {
  name = "json-example-workgroup"

  configuration {
    # This override any client configurations
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = false
    bytes_scanned_cutoff_per_query     = 10485760

    result_configuration {
      output_location = "s3://${aws_s3_bucket.s3.bucket}/athena/"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }

  force_destroy = true
}
