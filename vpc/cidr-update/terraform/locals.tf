data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  vpc_name = "vpc-cidr-update-example"
  region   = data.aws_region.current.name
}
