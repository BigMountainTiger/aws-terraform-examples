resource "aws_api_gateway_stage" "stage" {
  rest_api_id   = var.rest_api_id
  deployment_id = var.deployment_id
  stage_name    = var.stage_name
}