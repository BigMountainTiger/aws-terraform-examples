provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    encrypt      = true
    bucket       = "terraform.huge.head.li"
    use_lockfile = true
    key          = "ecs-examples-basic-task-fargate-web-task"
    region       = "us-east-1"
  }
}
