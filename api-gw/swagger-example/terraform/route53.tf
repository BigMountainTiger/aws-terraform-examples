data "aws_acm_certificate" "acm_certificate" {
  domain      = local.acm_domain_name
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "primary" {
  name         = local.route53_zone_name
  private_zone = false
}

resource "aws_route53_record" "swagger_route53_record" {
  count = local.deploy_cloudfront ? 1 : 0

  zone_id = data.aws_route53_zone.primary.zone_id
  name    = local.swagger_domain_name
  type    = "CNAME"
  ttl     = "60"

  records = [
    aws_cloudfront_distribution.s3_distribution[0].domain_name
  ]
}

resource "aws_route53_record" "api_route53_record" {
  name    = local.api_domain_name
  zone_id = data.aws_route53_zone.primary.zone_id
  type    = "A"

  alias {
    zone_id = aws_api_gateway_domain_name.api.regional_zone_id
    name    = aws_api_gateway_domain_name.api.regional_domain_name

    evaluate_target_health = false
  }
}
