terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform.huge.head.li.2023"
    dynamodb_table = "terraform-state-lock"
    key            = "sns-sqs-sns-lambda"
    region         = "us-east-1"
  }
}