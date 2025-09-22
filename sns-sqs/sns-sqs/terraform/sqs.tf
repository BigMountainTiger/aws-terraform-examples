locals {
  visibility_timeout = 60
}

resource "aws_sqs_queue" "queue" {
  name                       = local.sqs_name
  visibility_timeout_seconds = local.visibility_timeout
}

# Add the sns to the principal so it is able to send message to the queue
resource "aws_sqs_queue_policy" "queue" {
  queue_url = aws_sqs_queue.queue.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : [
            "${aws_sns_topic.topic.arn}"
          ],
          "Action" : [
            "sqs:SendMessage",
            "sqs:ReceiveMessage",
            "sqs:DeleteMessage",
            "sqs:GetQueueAttributes"
          ],
          "Resource" : "${aws_sqs_queue.queue.arn}"
        }
      ]
  })
}


resource "aws_sns_topic_subscription" "queue" {
  topic_arn = aws_sns_topic.topic.arn
  endpoint  = aws_sqs_queue.queue.arn
  protocol  = "sqs"
}
