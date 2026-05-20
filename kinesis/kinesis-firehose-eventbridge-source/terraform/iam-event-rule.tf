resource "aws_iam_role" "event_rule" {
  name = "kinesis_firehose_event_rule_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "events.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "event_rule" {
  name = "kinesis_firehose_event_rule_role"
  role = aws_iam_role.event_rule.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "firehose:PutRecord",
          "firehose:PutRecordBatch"
        ],
        "Resource" : [
          "${aws_kinesis_firehose_delivery_stream.s3.arn}"
        ]
      }
    ]
  })
}
