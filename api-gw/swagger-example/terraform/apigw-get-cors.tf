# https://mrponath.medium.com/terraform-and-aws-api-gateway-a137ee48a8ac

resource "aws_api_gateway_method" "get_cors" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.get.id
  http_method = "OPTIONS"

  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_cors" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.get.id
  http_method = aws_api_gateway_method.get_cors.http_method
  type        = "MOCK"

  # https://stackoverflow.com/questions/59911777/aws-api-gateway-and-static-html-execution-failed-due-to-configuration-error-s
  request_templates = {
    "application/json" = jsonencode({
      statusCode : 200
    })
  }

  depends_on = [
    aws_api_gateway_method.get_cors
  ]
}

resource "aws_api_gateway_method_response" "get_cors" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.get.id
  http_method = aws_api_gateway_method.get_cors.http_method

  status_code = 200
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = [
    aws_api_gateway_method.get_cors
  ]
}

resource "aws_api_gateway_integration_response" "get_cors" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.get.id
  http_method = aws_api_gateway_method.get_cors.http_method

  status_code = aws_api_gateway_method_response.get_cors.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'*'",
    "method.response.header.Access-Control-Allow-Methods" = "'*'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

