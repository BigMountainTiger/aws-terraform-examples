resource "aws_sqs_queue" "queue" {
  name                       = "example-sqs-queue"
  visibility_timeout_seconds = local.visibility_timeout

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.queue_deadletter.arn
    maxReceiveCount     = 3
  })
}


resource "aws_sqs_queue" "queue_deadletter" {
  name = "example-sqs-queue-deadletter"
}

resource "aws_sqs_queue_redrive_allow_policy" "queue_deadletter" {
  queue_url = aws_sqs_queue.queue_deadletter.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.queue.arn]
  })
}
