resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  # This force the api gateway to always deploy
  description = "Deployed at ${timestamp()}"
  stage_description = timestamp()
  triggers = {
    redeployment = timestamp()
  }

  depends_on = [
    aws_api_gateway_method.sect_2,
    aws_api_gateway_integration.sect_2
  ]

  lifecycle {
    create_before_destroy = true
  }
}
