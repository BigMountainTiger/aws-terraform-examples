locals {
  function_name = "parameter_store_example_lambda"
}

data "archive_file" "zip" {
  type        = "zip"
  output_path = "${path.module}/../.tf-zip/${local.function_name}.zip"
  source_dir  = "${path.module}/../lambdas/${local.function_name}"
}

resource "aws_lambda_function" "lambda" {
  function_name = local.function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "app.lambdaHandler"
  runtime       = "python3.12"

  memory_size = 128
  timeout     = 5

  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  environment {
    variables = {
      SSM_PARAMETER_NAME = aws_ssm_parameter.parameter.name
    }
  }

  depends_on = [
    data.archive_file.zip
  ]
}
