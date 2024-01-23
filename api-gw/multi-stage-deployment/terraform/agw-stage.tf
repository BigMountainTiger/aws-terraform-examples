module "stage_1" {
  source = "./modules/api-gateway-stage"

  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  deployment_id = aws_api_gateway_deployment.deployment.id
  stage_name    = "stage1"
}

module "stage_2" {
  source = "./modules/api-gateway-stage"

  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  deployment_id = aws_api_gateway_deployment.deployment.id
  stage_name    = "stage2"
}
