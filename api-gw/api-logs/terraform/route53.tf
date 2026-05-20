locals {
  route53_zone_name    = "bigmountaintiger.com"
  www_certificate_name = "*.bigmountaintiger.com"
  www_domain_name      = "www.${local.route53_zone_name}"
}

# Need to create the certificate if not already exists
data "aws_acm_certificate" "acm_certificate" {
  domain      = local.www_certificate_name
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "primary" {
  name         = local.route53_zone_name
  private_zone = false
}

# Domain
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

# Path mapping
resource "aws_api_gateway_base_path_mapping" "path_mapping" {
  api_id      = aws_api_gateway_rest_api.api.id
  domain_name = aws_api_gateway_domain_name.domain_name.domain_name
  stage_name  = aws_api_gateway_stage.stage.stage_name

  depends_on = [
    aws_api_gateway_domain_name.domain_name,
    aws_api_gateway_stage.stage
  ]
}

# ARecord
resource "aws_route53_record" "ARecord" {
  name    = local.www_domain_name
  zone_id = data.aws_route53_zone.primary.zone_id
  type    = "A"

  alias {
    name    = aws_api_gateway_domain_name.domain_name.regional_domain_name
    zone_id = aws_api_gateway_domain_name.domain_name.regional_zone_id

    evaluate_target_health = false
  }
}
