# API gateway
resource "aws_api_gateway_rest_api" "apigw" {
  name = local.app_name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Resource, method, integration
resource "aws_api_gateway_resource" "example" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  path_part   = "example"
}

resource "aws_api_gateway_method" "example" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.example.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "example" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.example.id
  http_method             = aws_api_gateway_method.example.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api_executor.invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id       = aws_api_gateway_rest_api.apigw.id
  stage_description = "Deployed at ${timestamp()}"

  depends_on = [
    aws_api_gateway_integration.example
  ]

  lifecycle {
    create_before_destroy = true
  }
}
