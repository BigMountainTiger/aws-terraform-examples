

resource "aws_iam_role" "lambda_execution_role" {
  name = local.app_name
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
  name = local.app_name
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

# Lambda
data "archive_file" "zip" {
  type        = "zip"
  output_path = "${path.module}/../.tf-zip/example.zip"
  source_dir  = "${path.module}/../lambdas/example"
}

resource "aws_lambda_function" "lambda" {
  function_name = local.app_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "app.lambdaHandler"
  runtime       = "python3.10"

  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  depends_on = [
    data.archive_file.zip
  ]
}
