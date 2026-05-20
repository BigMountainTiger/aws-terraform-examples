locals {
  lambda_name = "${var.rule_name}-${var.target_name}-handler"
  lambda_envs = merge(
    var.config_envs,
    {
      BUCKET      = var.data_bucket
      SECRET_NAME = var.credential_secret
    }
  )
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

  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_sha512
  # source_code_hash = sha512("Never_replace_lambda_code")

  environment {
    variables = local.lambda_envs
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
