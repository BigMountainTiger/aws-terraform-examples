resource "aws_iam_role" "cloudwatch_to_firehose_role" {
  name = "cloudwatch_metric_stream_to_firehose_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "streams.metrics.cloudwatch.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "cloudwatch_to_firehose_role" {
  name = "cloudwatch_metric_stream_to_firehose_role_policy"
  role = aws_iam_role.cloudwatch_to_firehose_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "firehose:PutRecord",
          "firehose:PutRecordBatch"
        ],
        "Resource" : "*"
      }
    ]
  })
}
