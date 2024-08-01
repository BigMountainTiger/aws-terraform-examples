

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

# 1. Use replace_triggered_by to force a replacement, if runtime is updated
# 2. If the lambda "Runtime management configuration" is set to "manual", we can not update the runtime version
variable "lambda_runtime" {
  default = "python3.12"
}

resource "terraform_data" "lambda_runtime" {
  input = var.lambda_runtime
}

resource "aws_lambda_function" "lambda" {
  function_name = local.app_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "app.lambdaHandler"
  runtime       = var.lambda_runtime

  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  depends_on = [
    data.archive_file.zip,
    terraform_data.lambda_runtime
  ]

  lifecycle {
    replace_triggered_by = [
      terraform_data.lambda_runtime
    ]
  }
}

# Only available after provider > 5.51.0
resource "aws_lambda_runtime_management_config" "example" {
  function_name       = aws_lambda_function.lambda.function_name
  update_runtime_on   = var.lambda_runtime_config.update_runtime_on
  qualifier           = var.lambda_runtime_config.qualifier
  runtime_version_arn = var.lambda_runtime_config.runtime_version_arn

  depends_on = [
    aws_lambda_function.lambda
  ]
}
