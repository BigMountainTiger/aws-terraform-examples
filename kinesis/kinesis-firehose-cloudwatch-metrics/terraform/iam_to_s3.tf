# https://docs.aws.amazon.com/firehose/latest/dev/controlling-access.html

locals {
  s3_role_name        = "kinesis_firehose_cloudwatch_metrics_s3_role"
  s3_role_policy_name = "kinesis_firehose_cloudwatch_metrics_s3_role_policy"

}

resource "aws_iam_role" "s3_role" {
  name = local.s3_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "firehose.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

locals {
  deploy_s3_role_s3_policy    = true
  deploy_s3_role_other_policy = true
}

resource "aws_iam_role_policy" "s3_role_policy" {
  count = local.deploy_s3_role_s3_policy ? 1 : 0

  name = local.s3_role_policy_name
  role = aws_iam_role.s3_role.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ],
        "Resource" : [
          "${resource.aws_s3_bucket.kinesis_example_s3.arn}",
          "${resource.aws_s3_bucket.kinesis_example_s3.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "s3_role_other_policy" {
  count = local.deploy_s3_role_other_policy ? 1 : 0

  name = "kinesis_firehose_s3_role_policy_other_policy"
  role = aws_iam_role.s3_role.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "kinesis:DescribeStream",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:ListShards"
        ],
        "Resource" : ["*"]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        "Resource" : ["*"]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "${aws_cloudwatch_log_stream.log.arn}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "lambda:InvokeFunction",
          "lambda:GetFunctionConfiguration"
        ],
        "Resource" : ["*"]
      }
    ]
  })
}
