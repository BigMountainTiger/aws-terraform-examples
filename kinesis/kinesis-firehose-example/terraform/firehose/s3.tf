locals {
  bucket_name = "kinesis-example-bucket-huge-head-li"
}

data "aws_s3_bucket" "kinesis_example_s3" {
  bucket = local.bucket_name
}
