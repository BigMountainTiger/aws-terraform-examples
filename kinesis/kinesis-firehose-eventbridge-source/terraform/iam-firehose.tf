# https://docs.aws.amazon.com/firehose/latest/dev/controlling-access.html

resource "aws_iam_role" "firehose" {
  name = "kinesis_firehose_eventbridge_to_s3_role"
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

resource "aws_iam_role_policy" "firehose" {

  name = "kinesis_firehose_eventbridge_to_s3_role"
  role = aws_iam_role.firehose.name
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
      },
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
          "${aws_s3_bucket.s3.arn}",
          "${aws_s3_bucket.s3.arn}/*"
        ]
      },
      {
        "Action" : [
          "lambda:InvokeFunction",
          "lambda:GetFunctionConfiguration"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "${aws_lambda_function.lambda.arn}"
        ]
      }
    ]
  })
}
