data "archive_file" "api-executor_zip" {
  type        = "zip"
  output_path = "${path.module}/.tf-zip/api-executor.zip"
  source_dir  = "${path.module}/lambdas/api-executor"
}

resource "aws_lambda_function" "api-executor" {
  function_name    = "api-executor"
  filename         = data.archive_file.api-executor_zip.output_path
  source_code_hash = data.archive_file.api-executor_zip.output_base64sha256
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "app.lambdaHandler"
  runtime          = "python3.9"
  depends_on = [
    data.archive_file.api-executor_zip
  ]
}

data "archive_file" "api-authorizor_zip" {
  type        = "zip"
  output_path = "${path.module}/.tf-zip/api-authorizor.zip"
  source_dir  = "${path.module}/lambdas/api-authorizor"
}

resource "aws_lambda_function" "api-authorizor" {
  function_name    = "api-authorizor"
  filename         = data.archive_file.api-authorizor_zip.output_path
  source_code_hash = data.archive_file.api-authorizor_zip.output_base64sha256
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "app.lambdaHandler"
  runtime          = "python3.9"
  environment {
    variables = {
      "JWKS_DOMAIN" = var.jwks_doman
      "JWKS_PATH"   = var.jwks_path
    }
  }
  depends_on = [
    data.archive_file.api-authorizor_zip
  ]
}
