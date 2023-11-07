locals {
  lambda_file = "../.tf-zip/lambda-function.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name    = "dynamodb-transaction-test-lambda"
  filename         = local.lambda_file
  source_code_hash = filebase64sha256(local.lambda_file)
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "src.lambda_function.lambda_handler"
  runtime          = "python3.9"
  timeout          = 3
  memory_size      = 128
}

