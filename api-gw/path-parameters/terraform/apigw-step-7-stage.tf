locals {
  stage_name = "test"
}

resource "aws_api_gateway_stage" "stage" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.deployment.id
  stage_name    = local.stage_name
}

output "http_url" {
  value = aws_api_gateway_stage.stage.invoke_url
}
