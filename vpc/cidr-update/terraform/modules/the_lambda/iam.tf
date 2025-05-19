resource "aws_iam_role" "lambda_execution_role" {
  name = var.lambda_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_execution_role" {
  name   = var.lambda_name
  role   = aws_iam_role.lambda_execution_role.name
  policy = data.aws_iam_policy_document.lambda_execution_role.json
}

data "aws_iam_policy_document" "lambda_execution_role" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = [
      "arn:aws:logs:${local.aws_region}:${local.aws_account_id}:*"
    ]
  }
}

# https://docs.aws.amazon.com/lambda/latest/dg/configuration-vpc.html
resource "aws_iam_role_policy_attachment" "lambda_execution_role_vpc" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.lambda_execution_role.name
}

