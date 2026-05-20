resource "aws_iam_role" "lambda_role" {
  name = "parameter_store_example_lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_execution_role" {
  name = "lambda_execution_role_policy"
  role = aws_iam_role.lambda_role.name
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
          "arn:aws:logs:${local.aws_region}:${local.aws_account_id}:*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ssm:GetParameter"
        ],
        "Resource" : [
          "arn:aws:ssm:${local.aws_region}:${local.aws_account_id}:parameter/*"
        ]
      }
    ]
  })
}

