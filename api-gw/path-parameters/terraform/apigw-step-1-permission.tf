# Allow the API gateway to invoke the lambdas
resource "aws_lambda_permission" "executor" {
  statement_id  = "apigw-invoke-executor"
  function_name = module.executor.function_name
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
}

resource "aws_lambda_permission" "authorizer" {
  statement_id  = "apigw-invoke-authorizer"
  function_name = module.authorizor.function_name
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
}