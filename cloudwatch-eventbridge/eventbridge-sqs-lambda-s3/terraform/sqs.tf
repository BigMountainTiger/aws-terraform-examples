resource "aws_sqs_queue" "queue" {
  name = "eventbridge-sqs-example-queue"

  visibility_timeout_seconds = 60
}

resource "aws_sqs_queue_policy" "queue" {
  queue_url = aws_sqs_queue.queue.id

  # This is the minimal permission for the event rule
  # to send event to the SQS
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
        "Resource" : "${aws_sqs_queue.queue.arn}",
        "Condition" : {
          "ArnEquals" : {
            "aws:SourceArn" : "${aws_cloudwatch_event_rule.rule.arn}"
          }
        }
      }
    ]
  })

}