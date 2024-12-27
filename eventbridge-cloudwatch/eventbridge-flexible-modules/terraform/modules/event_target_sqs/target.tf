locals {
  sqs_name = "${var.rule_name}-${var.target_purpose}"
}

resource "aws_sqs_queue" "sqs" {
  name = local.sqs_name

  sqs_managed_sse_enabled    = true
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_event_target" "sqs" {
  event_bus_name = var.event_bus_name

  rule = var.rule_name
  arn  = aws_sqs_queue.sqs.arn
}
