locals {

}

resource "aws_api_gateway_rest_api" "api" {
  name = local.app_name

  # The default is edge optimized
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_rest_api.api.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_rest_api.api.root_resource_id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

resource "aws_lambda_permission" "executor" {
  statement_id  = "apigw-invoke-executor"
  function_name = aws_lambda_function.lambda.function_name
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  # This force the api gateway to always deploy
  description       = "Deployed at ${timestamp()}"
  stage_description = timestamp()
  triggers = {
    redeployment = timestamp()
  }

  depends_on = [
    aws_api_gateway_method.method,
    aws_api_gateway_integration.integration
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.deployment.id
  stage_name    = "default"

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.access_log.arn

    # https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html
    format = jsonencode({
      "stage" : "$context.stage",
      "request_id" : "$context.requestId",
      "api_id" : "$context.apiId",
      "status" : "$context.status"
    })
  }
}

output "http_url" {
  value = aws_api_gateway_stage.stage.invoke_url
}

