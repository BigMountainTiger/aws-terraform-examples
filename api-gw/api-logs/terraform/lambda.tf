locals {
  role_name     = "${local.app_name}-lambda_execution_role"
  function_name = "${local.app_name}-executor"
}

data "archive_file" "zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/api-executor"
  output_path = "${path.module}/../.tf-zip/executor.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name = local.function_name
  role          = aws_iam_role.lambda_execution_role.arn
  runtime       = "python3.12"
  handler       = "app.lambdaHandler"

  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  depends_on = [
    data.archive_file.zip
  ]
}

resource "aws_iam_role" "lambda_execution_role" {
  name = local.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_execution_role" {
  name = local.role_name
  role = aws_iam_role.lambda_execution_role.name
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
        "Resource" : "*"
      }
    ]
  })
}


