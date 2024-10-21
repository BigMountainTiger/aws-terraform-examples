resource "aws_iam_role" "lambda_role" {
  name = "eventbridge_sqs_example_lambda_execution_role"
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
          "arn:aws:logs:*:${local.aws_account_id}:*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:ListKeys",
          "kms:ListAliases",
          "kms:GetPublicKey",
          "kms:DescribeKey",
          "kms:Decrypt"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "kms:CallerAccount" : "${local.aws_account_id}"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue"
        ],
        "Resource" : [
          "arn:aws:secretsmanager:*:${local.aws_account_id}:*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:GetObject",
          "s3:PutObject"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.s3.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.s3.bucket}/*"
        ]
      }
    ]
  })
}

