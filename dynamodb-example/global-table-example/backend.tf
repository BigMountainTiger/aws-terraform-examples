terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform.huge.head.li"
    dynamodb_table = "terraform-state-lock"
    key            = "dynamodb-global-table-example"
    region         = "us-east-1"
  }
}
