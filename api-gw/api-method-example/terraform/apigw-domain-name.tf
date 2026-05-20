locals {
  www_certificate_name = "*.bigmountaintiger.com"
  www_domain_name      = "www.bigmountaintiger.com"
}

data "aws_acm_certificate" "acm_certificate" {
  domain      = local.www_certificate_name
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_apigatewayv2_domain_name" "api" {
  domain_name = local.www_domain_name

  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.acm_certificate.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "api" {
  api_id      = aws_api_gateway_rest_api.api_gw.id
  domain_name = aws_apigatewayv2_domain_name.api.domain_name
  stage       = aws_api_gateway_stage.gateway_stage.stage_name

  depends_on = [
    aws_api_gateway_deployment.gateway_deployment,
    aws_api_gateway_stage.gateway_stage
  ]
}

resource "aws_route53_record" "example" {
  name    = local.www_domain_name
  zone_id = data.aws_route53_zone.primary.zone_id
  type    = "A"

  alias {
    name    = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].target_domain_name
    zone_id = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].hosted_zone_id

    evaluate_target_health = false
  }
}

