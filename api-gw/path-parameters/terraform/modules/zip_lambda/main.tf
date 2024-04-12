variable "function_name" {}
variable "role_arn" {}
variable "runtime" {}
variable "handler" {}

variable "source_dir" {}
variable "zip_output_path" {}

output "arn" {
  value = aws_lambda_function.lambda.arn
}

output "invoke_arn" {
  value = aws_lambda_function.lambda.invoke_arn
}

output "function_name" {
  value = aws_lambda_function.lambda.function_name
}

data "archive_file" "zip" {
  type        = "zip"
  output_path = var.zip_output_path
  source_dir  = var.source_dir
}

resource "aws_lambda_function" "lambda" {
  function_name = var.function_name
  role          = var.role_arn
  runtime       = var.runtime
  handler       = var.handler

  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  depends_on = [
    data.archive_file.zip
  ]
}
