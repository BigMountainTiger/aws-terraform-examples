resource "aws_cloudwatch_event_rule" "event_rule" {
  name = local.eventbridge_rule_name

  event_bus_name = "default"
  event_pattern  = var.eventbridge_rule_pattern
  force_destroy  = true
}

resource "aws_cloudwatch_event_target" "event_target" {
  rule = aws_cloudwatch_event_rule.event_rule.name
  arn  = aws_sqs_queue.queue.arn

  depends_on = [
    aws_sqs_queue.queue,
    aws_cloudwatch_event_rule.event_rule
  ]
}

