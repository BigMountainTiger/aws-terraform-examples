locals {
  route53_zone_name = "bigmountaintiger.com"
}

data "aws_route53_zone" "primary" {
  name         = local.route53_zone_name
  private_zone = false
}

resource "aws_route53_record" "example" {
  name    = local.www_domain_name
  zone_id = data.aws_route53_zone.primary.zone_id
  type    = "A"

  alias {
    name    = aws_api_gateway_domain_name.domain_name.regional_domain_name
    zone_id = aws_api_gateway_domain_name.domain_name.regional_zone_id

    evaluate_target_health = false
  }
}
