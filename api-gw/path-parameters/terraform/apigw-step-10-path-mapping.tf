resource "aws_api_gateway_base_path_mapping" "path_mapping" {
  api_id      = aws_api_gateway_rest_api.api.id
  domain_name = aws_api_gateway_domain_name.domain_name.domain_name
  stage_name  = aws_api_gateway_stage.stage.stage_name

  depends_on = [
    aws_api_gateway_domain_name.domain_name,
    aws_api_gateway_stage.stage
  ]
}
