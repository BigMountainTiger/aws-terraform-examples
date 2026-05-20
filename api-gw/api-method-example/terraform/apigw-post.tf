resource "aws_api_gateway_resource" "post" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  parent_id   = aws_api_gateway_rest_api.api_gw.root_resource_id
  path_part   = "post"
}

resource "aws_api_gateway_method" "post" {
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id
  resource_id   = aws_api_gateway_resource.post.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post" {
  rest_api_id             = aws_api_gateway_rest_api.api_gw.id
  resource_id             = aws_api_gateway_resource.post.id
  http_method             = aws_api_gateway_method.post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.template_lambda.invoke_arn
}
