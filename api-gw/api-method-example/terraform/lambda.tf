data "archive_file" "template_lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/../.tf-zip/template-lambda.zip"
  source_dir  = "${path.module}/../lambdas/.template-lambda"
}

resource "aws_lambda_function" "template_lambda" {
  function_name    = "${local.app_name}-template-lambda"
  filename         = data.archive_file.template_lambda_zip.output_path
  source_code_hash = data.archive_file.template_lambda_zip.output_base64sha256
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "app.lambdaHandler"
  runtime          = "python3.10"
  depends_on = [
    data.archive_file.template_lambda_zip
  ]
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "${local.app_name}_lambda_execution_role"
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
  name = "${local.app_name}_lambda_execution_role_policy"
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
          "rds:DescribeDBInstances"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "rds-db:connect"
        ],
        "Resource" : [
          "arn:aws:rds-db:us-east-1:${data.aws_caller_identity.current.account_id}:dbuser:*/api_user"
        ]
      }
    ]
  })
}
