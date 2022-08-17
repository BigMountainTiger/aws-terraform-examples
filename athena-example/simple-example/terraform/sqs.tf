resource "aws_sqs_queue" "event_sqs_queue" {
  name = "athena-example-event-queue"
}

resource "aws_cloudwatch_event_target" "sqs" {
  rule      = aws_cloudwatch_event_rule.athena_event.name
  arn       = aws_sqs_queue.event_sqs_queue.arn
}

resource "aws_sqs_queue_policy" "event_sqs_queue" {
  queue_url = aws_sqs_queue.event_sqs_queue.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : "*",
          "Action" : "sqs:SendMessage",
          "Resource" : "${aws_sqs_queue.event_sqs_queue.arn}"
        }
      ]
  })
}
