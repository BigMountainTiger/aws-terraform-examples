data "archive_file" "zip_consumer" {
  type        = "zip"
  output_path = "${path.module}/.tf-zip/sqs_consumer.zip"
  source_dir  = "${path.module}/lambdas/sqs_consumer"
}


resource "aws_lambda_function" "lambda_consumer" {
  function_name = local.lambda_consumer_name
  role          = aws_iam_role.lambda_consumer_execution_role.arn
  handler       = "app.lambdaHandler"
  runtime       = "python3.12"

  filename = data.archive_file.zip_consumer.output_path

  # If we do not want to update the lambda code from terraform   
  # source_code_hash = base64sha256("Never_replace_lambda_code")

  source_code_hash = data.archive_file.zip_consumer.output_base64sha256

  tags = {}

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_iam_role" "lambda_consumer_execution_role" {
  name = local.lambda_consumer_name
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

# It looks like the sqs permission is requried here
# so the aws_lambda_event_source_mapping can be created
resource "aws_iam_role_policy" "lambda_consumer_execution_role" {
  name = local.lambda_consumer_name
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

resource "aws_lambda_event_source_mapping" "lambda" {
  event_source_arn = aws_sqs_queue.queue.arn
  function_name    = aws_lambda_function.lambda_consumer.arn
  batch_size       = "1"
  enabled          = true
}
