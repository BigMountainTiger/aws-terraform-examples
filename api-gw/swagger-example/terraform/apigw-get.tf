# Resource
resource "aws_api_gateway_resource" "get" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  parent_id   = aws_api_gateway_rest_api.api_gw.root_resource_id
  path_part   = "get"
}

# Method
resource "aws_api_gateway_method" "get" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.get.id
  http_method = "GET"

  # authorization = "NONE"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.authorizer.id

  request_parameters = local.get_query_params
}

# Integration
resource "aws_api_gateway_integration" "get" {
  rest_api_id             = aws_api_gateway_rest_api.api_gw.id
  resource_id             = aws_api_gateway_resource.get.id
  http_method             = aws_api_gateway_method.get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.template_lambda.invoke_arn
}

# Response model
resource "aws_api_gateway_model" "get_200" {
  rest_api_id  = aws_api_gateway_rest_api.api_gw.id
  name         = "GetResponse"
  content_type = "application/json"

  schema = local.get_response_schema
}

# Response 200 -> use Response model
resource "aws_api_gateway_method_response" "get_200" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.get.id
  http_method = aws_api_gateway_method.get.http_method

  status_code = "200"
  response_models = {
    "application/json" = aws_api_gateway_model.get_200.name
  }

  depends_on = [
    aws_api_gateway_model.get_200
  ]
}

