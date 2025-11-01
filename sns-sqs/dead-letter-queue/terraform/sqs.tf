locals {
  sqs_name = "example-queue"
  dlq_name = "${local.sqs_name}-dlq"
}

resource "aws_sqs_queue" "queue" {
  name = local.sqs_name

  sqs_managed_sse_enabled    = true
  visibility_timeout_seconds = 2 * local.lambda_timeout
  message_retention_seconds  = 1209600

  redrive_policy = jsonencode({
    deadLetterTargetArn = "${aws_sqs_queue.queue_dlq.arn}"
    maxReceiveCount     = 3
  })
}

resource "aws_sqs_queue_policy" "queue" {
  queue_url = aws_sqs_queue.queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action   = "SQS:SendMessage"
        Resource = "${aws_sqs_queue.queue.arn}"
      }
    ]
  })
}

resource "aws_sqs_queue" "queue_dlq" {
  name = local.dlq_name

  sqs_managed_sse_enabled   = true
  message_retention_seconds = 1209600
}

resource "aws_sqs_queue_redrive_allow_policy" "queue_dlq" {
  queue_url = aws_sqs_queue.queue_dlq.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = ["${aws_sqs_queue.queue.arn}"]
  })
}
