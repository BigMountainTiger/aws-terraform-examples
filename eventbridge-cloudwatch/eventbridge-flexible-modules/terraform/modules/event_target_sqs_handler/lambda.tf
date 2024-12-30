locals {
  lambda_name = "${replace(var.sqs_name, "-${var.environment}", "")}-handler-${var.environment}"
}

data "archive_file" "zip" {
  type        = "zip"
  output_path = "${path.module}/.tf-zip/lambda_handler.zip"
  source_dir  = "${path.module}/templates/default_handler"
}

resource "aws_lambda_function" "lambda" {
  function_name = local.lambda_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "app.lambda_handler"
  runtime       = var.lambda_runtime

  memory_size = var.lambda_memory_size
  timeout     = var.lambda_timeout

  filename         = data.archive_file.zip.output_path
  source_code_hash = base64sha512("Never_replace_lambda_code")

  environment {
    variables = var.lambda_config_envs
  }

  depends_on = [
    data.archive_file.zip,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_event_source_mapping" "name" {
  event_source_arn = var.sqs_arn
  function_name    = aws_lambda_function.lambda.arn

  # default batch window is 0 - lambda invoked immediately
  maximum_batching_window_in_seconds = var.sqs_batch_window
  batch_size                         = var.sqs_batch_size

  enabled = var.sqs_mapping_enabled
}
