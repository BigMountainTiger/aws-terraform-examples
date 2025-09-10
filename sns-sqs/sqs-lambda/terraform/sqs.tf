resource "aws_sqs_queue" "queue" {
  name                       = "example-sqs-queue"
  visibility_timeout_seconds = local.visibility_timeout
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
			"Resource": "${aws_sqs_queue.queue.arn}",
      "Condition": {
        "StringEquals": {
          "aws:PrincipalAccount": "${data.aws_caller_identity.current.account_id}"
        }
      }
		}
	]
}
EOF

}
