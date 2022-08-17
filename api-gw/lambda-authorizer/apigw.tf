resource "aws_lambda_permission" "apigw_api-executor_permission" {
  statement_id  = "apigw_api-executor_permission"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api-executor.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_lambda_permission" "apigw_api-authorizor_permission" {
  statement_id  = "apigw_api-executor_permission"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api-authorizor.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_rest_api" "test_api_gw" {
  name = "hello_world"
}

resource "aws_api_gateway_authorizer" "authorizer" {
  name                             = "authorizer"
  type                             = "REQUEST"
  identity_source                  = "method.request.header.Authorization"
  authorizer_result_ttl_in_seconds = 300
  rest_api_id                      = aws_api_gateway_rest_api.test_api_gw.id
  authorizer_uri                   = aws_lambda_function.api-authorizor.invoke_arn
  authorizer_credentials           = aws_iam_role.auth_invocation_role.arn
}

resource "aws_api_gateway_method" "api_root_get_method" {
  rest_api_id      = aws_api_gateway_rest_api.test_api_gw.id
  resource_id      = aws_api_gateway_rest_api.test_api_gw.root_resource_id
  http_method      = "GET"
  authorization    = "CUSTOM"
  authorizer_id    = aws_api_gateway_authorizer.authorizer.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "api_root_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.test_api_gw.id
  resource_id             = aws_api_gateway_rest_api.test_api_gw.root_resource_id
  http_method             = aws_api_gateway_method.api_root_get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api-executor.invoke_arn
}

resource "aws_api_gateway_deployment" "test_api_gw_deployment" {
  rest_api_id = aws_api_gateway_rest_api.test_api_gw.id
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.test_api_gw.body))
  }

  depends_on = [
    aws_api_gateway_method.api_root_get_method,
    aws_api_gateway_integration.api_root_get_integration
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api_gateway_stage" {
  deployment_id = aws_api_gateway_deployment.test_api_gw_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.test_api_gw.id
  stage_name    = "deploy_stage"
}

resource "aws_api_gateway_api_key" "api_key" {
  name  = "test_api_key"
  value = "Test-0123456789-0123456789-0123456789"
}

resource "aws_api_gateway_usage_plan" "usage_plan" {
  name = "test_usage_plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.test_api_gw.id
    stage  = aws_api_gateway_stage.api_gateway_stage.stage_name
  }

}

resource "aws_api_gateway_usage_plan_key" "usage_plan_key" {
  key_type      = "API_KEY"
  key_id        = aws_api_gateway_api_key.api_key.id
  usage_plan_id = aws_api_gateway_usage_plan.usage_plan.id
}

