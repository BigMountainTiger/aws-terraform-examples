
resource "aws_api_gateway_integration" "sect_2" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.sect_2.id
  http_method             = aws_api_gateway_method.sect_2.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.executor.invoke_arn
}

resource "aws_api_gateway_integration" "param_2" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.param_2.id
  http_method             = aws_api_gateway_method.param_2.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.executor.invoke_arn
}