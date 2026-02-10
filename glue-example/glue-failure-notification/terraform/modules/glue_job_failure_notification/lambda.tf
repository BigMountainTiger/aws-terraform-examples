resource "aws_iam_role" "email_notification_lambda" {
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

resource "aws_iam_role_policy" "email_notification_lambda" {
  name = local.lambda_name
  role = aws_iam_role.email_notification_lambda.name
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

resource "aws_lambda_function" "email_notification_lambda" {
  function_name = local.lambda_name
  role          = aws_iam_role.email_notification_lambda.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.12"
  filename      = data.archive_file.lambda_code_placeholder.output_path

  memory_size = local.lambda_memory_size
  timeout     = local.lambda_timeout

  source_code_hash = base64sha256("Never_replace_lambda_code")

  environment {
    variables = {
      VARIABLE_1 = "VARIABLE_1 value"
    }
  }
}

resource "aws_lambda_event_source_mapping" "email_notification_lambda" {
  event_source_arn = aws_sqs_queue.queue.arn
  function_name    = aws_lambda_function.email_notification_lambda.arn
  batch_size       = "1"
  enabled          = true
}
