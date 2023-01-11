locals {
  visibility-timeout = 60
}

resource "aws_sqs_queue" "queue" {
  name                       = "example-sqs-queue"
  visibility_timeout_seconds = local.visibility-timeout
  redrive_policy = jsonencode(
    {
      "deadLetterTargetArn" : "${aws_sqs_queue.queue_dlq.arn}",
      "maxReceiveCount" : 1
    }
  )
}

resource "aws_sqs_queue_policy" "queue" {
  queue_url = aws_sqs_queue.queue.id

  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Principal": "*",
			"Action": [
				"sqs:SendMessage",
				"sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
			],
			"Resource": "${aws_sqs_queue.queue.arn}"
		}
	]
}
EOF

}

resource "aws_sqs_queue" "queue_dlq" {
  name                       = "example-sqs-queue-dlq"
  visibility_timeout_seconds = local.visibility-timeout
}

resource "aws_sns_topic_subscription" "queue" {
  topic_arn = aws_sns_topic.example_sns_topic.arn
  endpoint  = aws_sqs_queue.queue.arn
  protocol  = "sqs"
}
