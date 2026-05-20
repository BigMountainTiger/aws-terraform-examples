resource "aws_api_gateway_domain_name" "api" {
  domain_name              = local.api_domain_name
  regional_certificate_arn = data.aws_acm_certificate.acm_certificate.arn
  security_policy          = "TLS_1_2"

  endpoint_configuration {
    types = [
      "REGIONAL"
    ]
  }
}

resource "aws_api_gateway_base_path_mapping" "api" {
  api_id      = aws_api_gateway_rest_api.api_gw.id
  domain_name = aws_api_gateway_domain_name.api.domain_name
  stage_name  = aws_api_gateway_stage.gateway_stage.stage_name
}


