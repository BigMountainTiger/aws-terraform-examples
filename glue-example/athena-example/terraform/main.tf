# glue database
resource "aws_glue_catalog_database" "athena_example_database" {
  name = local.athena_example_database_name
}

# s3 bucket
resource "aws_s3_bucket" "s3" {
  bucket = local.athena_example_s3_bucket_name

  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "s3" {
  bucket                  = aws_s3_bucket.s3.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Athena workgroup
resource "aws_athena_workgroup" "workgroup" {
  name = local.athena_workgroup_name

  configuration {
    # This override any client configurations
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = false

    # Need to be at least 10485760
    bytes_scanned_cutoff_per_query = 10485760

    result_configuration {
      output_location = "s3://${aws_s3_bucket.s3.bucket}/temp/athena/${local.athena_workgroup_name}"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }

  force_destroy = true
}
