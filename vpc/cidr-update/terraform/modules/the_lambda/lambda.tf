data "archive_file" "zip" {
  type        = "zip"
  output_path = "${path.module}/.tf-zip/lambda_handler.zip"
  source_dir  = "${path.module}/templates/default_handler"
}

resource "aws_lambda_function" "lambda" {
  function_name = var.lambda_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "app.lambda_handler"
  runtime       = var.lambda_runtime

  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_sha512

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  depends_on = [
    data.archive_file.zip,
  ]

  lifecycle {
    create_before_destroy = true
  }
}
