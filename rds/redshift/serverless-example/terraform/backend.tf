terraform {
  backend "s3" {
    encrypt      = true
    bucket       = "terraform.huge.head.li.2023"
    use_lockfile = true
    key          = "rds-redshift-serverless-example"
    region       = "us-east-1"
  }
}
