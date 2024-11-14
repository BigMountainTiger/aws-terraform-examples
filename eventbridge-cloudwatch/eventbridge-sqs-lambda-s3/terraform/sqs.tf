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

# It is confirmed that the following resource based policy is not needed
# as long as the lambda has a policy to grant the permissions to the SQS
# {
#   "Effect" : "Allow",
#   "Principal" : {
#     "Service" : "lambda.amazonaws.com"
#   },
#   "Action" : [
#     "sqs:SendMessage",
#     "sqs:ReceiveMessage",
#     "sqs:DeleteMessage",
#     "sqs:GetQueueAttributes"
#   ],
#   "Resource" : "${aws_sqs_queue.queue.arn}",
#   "Condition" : {
#     "ArnEquals" : {
#       "aws:SourceArn" : "${aws_lambda_function.lambda.arn}"
#     }
#   }
# }
