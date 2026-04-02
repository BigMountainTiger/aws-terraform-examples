resource "aws_sqs_queue" "queue" {
  name = local.sqs_queue_name

  visibility_timeout_seconds = local.lambda_timeout * 2
  redrive_policy = jsonencode({
    deadLetterTargetArn = "${aws_sqs_queue.queue_deadletter.arn}"
    maxReceiveCount     = 3
  })
}

resource "aws_sqs_queue_policy" "queue" {
  queue_url = aws_sqs_queue.queue.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : { "Service" : "events.amazonaws.com" },
        "Action" : "SQS:SendMessage",
        "Resource" : "${aws_sqs_queue.queue.arn}",
        "Condition" : {
          "ArnEquals" : {
            "aws:SourceArn" : "${aws_cloudwatch_event_rule.event_rule.arn}"
          }
        }
      }
    ]
  })
}

resource "aws_sqs_queue" "queue_deadletter" {
  name = "${local.sqs_queue_name}-deadletter"
}

resource "aws_sqs_queue_redrive_allow_policy" "queue_deadletter" {
  queue_url = aws_sqs_queue.queue_deadletter.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = ["${aws_sqs_queue.queue.arn}"]
  })
}

