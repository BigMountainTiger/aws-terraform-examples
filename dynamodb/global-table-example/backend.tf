terraform {
  backend "s3" {
    encrypt      = true
    bucket       = "terraform.huge.head.li"
    use_lockfile = true
    key          = "dynamodb-global-table-example"
    region       = "us-east-1"
  }
}
