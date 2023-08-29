# https://mrponath.medium.com/terraform-and-aws-api-gateway-a137ee48a8ac

resource "aws_api_gateway_method" "post_cors" {
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id
  resource_id   = aws_api_gateway_resource.post.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_cors" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.post.id
  http_method = aws_api_gateway_method.post_cors.http_method
  type        = "MOCK"

  depends_on = [
    aws_api_gateway_method.post_cors
  ]
}

resource "aws_api_gateway_method_response" "post_cors" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.post.id
  http_method = aws_api_gateway_method.post_cors.http_method

  status_code = 200
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = [aws_api_gateway_method.post_cors]
}

resource "aws_api_gateway_integration_response" "post_cors" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.post.id
  http_method = aws_api_gateway_method.post_cors.http_method

  status_code = aws_api_gateway_method_response.post_cors.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'",
    "method.response.header.Access-Control-Allow-Methods" = "'POST'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_integration.post_cors
  ]
}

