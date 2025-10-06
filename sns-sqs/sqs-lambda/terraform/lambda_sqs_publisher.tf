data "archive_file" "zip_publisher" {
  type        = "zip"
  output_path = "${path.module}/.tf-zip/sqs_publisher.zip"
  source_dir  = "${path.module}/lambdas/sqs_publisher"
}


resource "aws_lambda_function" "lambda_publisher" {
  function_name = local.lambda_publisher_name
  role          = aws_iam_role.lambda_publisher_execution_role.arn
  handler       = "app.lambdaHandler"
  runtime       = "python3.12"

  filename = data.archive_file.zip_publisher.output_path

  source_code_hash = data.archive_file.zip_publisher.output_base64sha256

  tags = {}

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_iam_role" "lambda_publisher_execution_role" {
  name = local.lambda_publisher_name
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

resource "aws_iam_role_policy" "lambda_publisher_execution_role" {
  name = local.lambda_publisher_name
  role = aws_iam_role.lambda_publisher_execution_role.name
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
          "sqs:SendMessage"
        ],
        "Resource" : [
          "${aws_sqs_queue.queue.arn}"
        ]
      }
    ]
  })
}
