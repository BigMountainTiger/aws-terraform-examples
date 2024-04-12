resource "aws_acm_certificate" "swagger" {
  domain_name       = local.swagger_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "swagger_certificate" {
  zone_id = data.aws_route53_zone.primary.zone_id

  name    = tolist(aws_acm_certificate.swagger.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.swagger.domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.swagger.domain_validation_options)[0].resource_record_value]

  ttl = 60
}

resource "aws_acm_certificate_validation" "swagger_certificate" {
  certificate_arn         = aws_acm_certificate.swagger.arn
  validation_record_fqdns = [aws_route53_record.swagger_certificate.fqdn]
}


