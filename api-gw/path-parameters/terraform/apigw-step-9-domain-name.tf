locals {
  www_domain_name = "www.bigmountaintiger.com"
}

resource "aws_api_gateway_domain_name" "domain_name" {
  domain_name              = local.www_domain_name
  regional_certificate_arn = data.aws_acm_certificate.acm_certificate.arn
  security_policy          = "TLS_1_2"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  depends_on = [
    data.aws_acm_certificate.acm_certificate
  ]
}

output "www_domain_name" {
  value = local.www_domain_name
}
