data "archive_file" "zip" {
  type        = "zip"
  output_path = "${path.module}/../.tf-zip/sqs_event_handler.zip"
  source_dir  = "${path.module}/../lambdas/sqs_event_handler"
}

resource "aws_lambda_function" "lambda" {
  function_name = "eventbridge_sqs_event_handler"
  role          = aws_iam_role.lambda.arn
  handler       = "app.lambdaHandler"
  runtime       = "python3.12"

  layers = [
    "arn:aws:lambda:us-east-1:336392948345:layer:AWSSDKPandas-Python312:13"
  ]

  memory_size = 128
  timeout     = 60

  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  depends_on = [
    data.archive_file.zip
  ]

}

# Need to set both batch window and batch size
# If no batch window set, the lambda is invoked immediately as long as a message coming to the queue
resource "aws_lambda_event_source_mapping" "lambda" {
  event_source_arn = aws_sqs_queue.queue.arn
  function_name    = aws_lambda_function.lambda.arn

  maximum_batching_window_in_seconds = 0

  batch_size = 3
  enabled    = true
}
