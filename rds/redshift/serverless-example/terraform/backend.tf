terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform.huge.head.li.2023"
    dynamodb_table = "terraform-state-lock"
    key            = "rds-redshift-serverless-example"
    region         = "us-east-1"
  }
}
