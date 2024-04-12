locals {
  www_certificate_name = "*.bigmountaintiger.com"
}

# Need to create the certificate if not already exists
data "aws_acm_certificate" "acm_certificate" {
  domain      = local.www_certificate_name
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}
