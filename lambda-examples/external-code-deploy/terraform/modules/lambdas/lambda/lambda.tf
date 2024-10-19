
locals {
  lambda_name = var.lambda_name
}

data "archive_file" "zip" {
  type        = "zip"
  output_path = "${path.module}/.tf-zip/python-lambda.zip"
  source_dir  = "${path.module}/lambda-templates/python-lambda"
}


resource "aws_lambda_function" "lambda" {
  function_name = local.lambda_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "app.lambdaHandler"
  runtime       = "python3.12"

  filename         = data.archive_file.zip.output_path
  source_code_hash = base64sha256("Never_replace_lambda_code")

  layers = [
    "arn:aws:lambda:us-east-1:336392948345:layer:AWSSDKPandas-Python312:13"
  ]

  tags = {}

  depends_on = [
    data.archive_file.zip
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "lambda_execution_role" {
  name = local.lambda_name
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
  name = local.lambda_name
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


