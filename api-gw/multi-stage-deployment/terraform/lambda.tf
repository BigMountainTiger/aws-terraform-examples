data "archive_file" "api-executor_zip" {
  type        = "zip"
  output_path = "${path.module}/.tf-zip/api-executor.zip"
  source_dir  = "${path.module}/../lambdas/api-executor"
}

resource "aws_lambda_function" "api_executor" {
  function_name    = "${local.app_name}-api-executor"
  filename         = data.archive_file.api-executor_zip.output_path
  source_code_hash = data.archive_file.api-executor_zip.output_base64sha256
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "app.lambdaHandler"
  runtime          = "python3.12"
  depends_on = [
    data.archive_file.api-executor_zip
  ]
}

# Allow lambda called by api gateway
resource "aws_lambda_permission" "api_executor" {
  statement_id  = "${local.app_name}-api-executor-apigw"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_executor.function_name
  principal     = "apigateway.amazonaws.com"
}