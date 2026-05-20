terraform {
  backend "s3" {
    encrypt      = true
    bucket       = "terraform.huge.head.li.2023"
    use_lockfile = true
    key          = "aurora-secret-rotation"
    region       = "us-east-1"
  }
}
