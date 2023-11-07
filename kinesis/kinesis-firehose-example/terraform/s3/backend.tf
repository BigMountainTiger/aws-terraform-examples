terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform.huge.head.li.2023"
    dynamodb_table = "terraform-state-lock"
    key            = "kinesis-firehose-example-s3"
    region         = "us-east-1"
  }
}
