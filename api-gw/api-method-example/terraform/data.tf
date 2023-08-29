data "aws_caller_identity" "current" {}

locals {
  route53_zone_name = "bigmountaintiger.com"
}

data "aws_route53_zone" "primary" {
  name         = local.route53_zone_name
  private_zone = false
}
