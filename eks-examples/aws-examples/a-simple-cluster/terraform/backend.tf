terraform {
  backend "s3" {
    encrypt      = true
    bucket       = "terraform.huge.head.li.2023"
    use_lockfile = true
    key          = "eks-examples-a-simple-cluster"
    region       = "us-east-1"
  }
}
