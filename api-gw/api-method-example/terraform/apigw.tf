resource "aws_lambda_permission" "lambda_execution_permission" {
  statement_id  = "lambda_execution_permission"
  function_name = aws_lambda_function.template_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  action        = "lambda:InvokeFunction"
  source_arn    = "${aws_api_gateway_rest_api.api_gw.execution_arn}/*"
}

resource "aws_api_gateway_rest_api" "api_gw" {
  name = local.app_name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id

  triggers = {
    redeployment = sha1(join("|",
      [
        jsonencode(aws_api_gateway_rest_api.api_gw),
        jsonencode(aws_api_gateway_resource.get),
        jsonencode(aws_api_gateway_method.get),
        jsonencode(aws_api_gateway_integration.get),
        jsonencode(aws_api_gateway_resource.post),
        jsonencode(aws_api_gateway_method.post),
        jsonencode(aws_api_gateway_integration.post)
      ]
    ))
  }

  depends_on = [
    aws_api_gateway_integration.get,
    aws_api_gateway_integration.post
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "gateway_stage" {
  deployment_id = aws_api_gateway_deployment.gateway_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id
  stage_name    = "deploy_stage"
}

