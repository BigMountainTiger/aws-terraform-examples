resource "aws_api_gateway_rest_api" "api_gw" {
  name = local.app_name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id

  # Make the deployment at every terraform apply
  stage_description = "Deployed at ${timestamp()}"

  depends_on = [
    aws_api_gateway_integration.post
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "gateway_stage" {
  deployment_id = aws_api_gateway_deployment.gateway_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id
  stage_name    = "deploy_stage"
}
