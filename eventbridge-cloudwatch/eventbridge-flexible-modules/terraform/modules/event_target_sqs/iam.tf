resource "aws_sqs_queue_policy" "sqs" {
  queue_url = aws_sqs_queue.sqs.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "events.amazonaws.com"
        },
        "Action" : [
          "sqs:SendMessage"
        ],
        "Resource" : "${aws_sqs_queue.sqs.arn}",
        "Condition" : {
          "ArnEquals" : {
            "aws:SourceArn" : "${var.rule_arn}"
          }
        }
      }
    ]
  })
}