data "archive_file" "zip_subscriber" {
  type        = "zip"
  output_path = "${path.module}/.tf-zip/sns_subscriber.zip"
  source_dir  = "${path.module}/lambdas/sns_subscriber"
}


resource "aws_lambda_function" "lambda_subcriber" {
  function_name = local.lambda_subscriber_name
  role          = aws_iam_role.lambda_subcriber_execution_role.arn
  handler       = "app.lambdaHandler"
  runtime       = "python3.12"

  filename = data.archive_file.zip_subscriber.output_path

  # If we do not want to update the lambda code from terraform   
  # source_code_hash = base64sha256("Never_replace_lambda_code")

  source_code_hash = data.archive_file.zip_subscriber.output_base64sha256

  tags = {}

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_iam_role" "lambda_subcriber_execution_role" {
  name = local.lambda_subscriber_name
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
resource "aws_iam_role_policy" "lambda_subcriber_execution_role" {
  name = local.lambda_subscriber_name
  role = aws_iam_role.lambda_subcriber_execution_role.name
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
      }
    ]
  })
}

resource "aws_lambda_permission" "sns_lambda_permission" {
  principal     = "sns.amazonaws.com"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_subcriber.function_name
  source_arn    = aws_sns_topic.topic.arn
}

resource "aws_sns_topic_subscription" "lambda_subscription" {
  protocol  = "lambda"
  topic_arn = aws_sns_topic.topic.arn
  endpoint  = aws_lambda_function.lambda_subcriber.arn
}
