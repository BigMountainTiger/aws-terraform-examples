locals {
  lambda_name    = "dead-letter-queue-example-consumer-lambda"
  lambda_timeout = 60
}

resource "aws_iam_role" "lambda_consumer_execution_role" {
  name = local.lambda_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_consumer_execution_role" {
  name = local.lambda_name
  role = aws_iam_role.lambda_consumer_execution_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        "Resource" : [
          "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ],
        "Resource" : [
          "${aws_sqs_queue.queue.arn}"
        ]
      }
    ]
  })
}

data "archive_file" "zip" {
  type        = "zip"
  output_path = "${path.module}/.tf-zip/${local.lambda_name}.zip"
  source_dir  = "${path.module}/lambda"
}


resource "aws_lambda_function" "lambda" {
  function_name = local.lambda_name
  role          = aws_iam_role.lambda_consumer_execution_role.arn
  handler       = "app.lambdaHandler"
  runtime       = "python3.12"

  filename = data.archive_file.zip.output_path

  # If we do not want to update the lambda code from terraform   
  # source_code_hash = base64sha256("Never_replace_lambda_code")

  source_code_hash = data.archive_file.zip.output_base64sha256

  tags = {}
}

resource "aws_lambda_event_source_mapping" "lambda" {
  event_source_arn = aws_sqs_queue.queue.arn
  function_name    = aws_lambda_function.lambda.arn
  batch_size       = "1"
  enabled          = true
}
