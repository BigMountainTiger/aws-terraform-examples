terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform.huge.head.li.2023"
    dynamodb_table = "terraform-state-lock"
    key            = "eks-examples-b-module-cluster"
    region         = "us-east-1"
  }
}
