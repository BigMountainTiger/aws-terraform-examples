locals {
  lambda_file = "../.tf-zip/lambda-function.zip"
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "secrete_rotation_lambda_execution_role"
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

resource "aws_iam_role_policy" "lambda_execution_role_policy" {
  name = "secrete_rotation_lambda_execution_role_policy"
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
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecretVersionStage"
        ],
        "Resource" : aws_secretsmanager_secret.password.arn
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetRandomPassword"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_lambda_function" "secrete_rotation_lambda" {
  function_name    = "secrete-rotation-lambda"
  filename         = local.lambda_file
  source_code_hash = filebase64sha256(local.lambda_file)
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "src.secrete_rotation_lambda.lambda_handler"
  runtime          = "python3.9"
  timeout          = 30
  memory_size      = 256
}

resource "aws_lambda_permission" "example_lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.secrete_rotation_lambda.function_name
  principal     = "secretsmanager.amazonaws.com"
}
