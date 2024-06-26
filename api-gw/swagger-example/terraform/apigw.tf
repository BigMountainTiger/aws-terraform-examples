resource "aws_api_gateway_rest_api" "api_gw" {
  name = local.app_name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_lambda_permission" "lambda_execution_permission" {
  statement_id  = "lambda_execution_permission"
  principal     = "apigateway.amazonaws.com"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.template_lambda.function_name
  source_arn    = "${aws_api_gateway_rest_api.api_gw.execution_arn}/*"
}

resource "aws_api_gateway_stage" "gateway_stage" {
  deployment_id = aws_api_gateway_deployment.gateway_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id
  stage_name    = "default"
}

resource "aws_api_gateway_deployment" "gateway_deployment" {
  rest_api_id       = aws_api_gateway_rest_api.api_gw.id

  # Make the deployment at every terraform apply
  stage_description = "Deployed at ${timestamp()}"

  depends_on = [
    aws_api_gateway_integration.get,
    aws_api_gateway_integration.get_cors
  ]

  lifecycle {
    create_before_destroy = true
  }
}


