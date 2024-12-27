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
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_execution_role" {
  name   = local.lambda_name
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

  statement {
    effect = "Allow"
    actions = [
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage"
    ]
    resources = [
      "${var.sqs_arn}"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${var.data_bucket}",
      "arn:aws:s3:::${var.data_bucket}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:ListKeys",
      "kms:ListAliases",
      "kms:GenerateDataKey",
      "kms:GetPublicKey",
      "kms:DescribeKey",
      "kms:Decrypt"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = ["${local.aws_account_id}"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = ["arn:aws:secretsmanager:${local.aws_region}:${local.aws_account_id}:secret:${var.credential_secret}*"]
  }
}
