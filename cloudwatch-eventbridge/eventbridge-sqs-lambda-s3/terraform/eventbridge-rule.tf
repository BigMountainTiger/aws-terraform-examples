resource "aws_cloudwatch_event_rule" "rule" {
  name           = aws_sqs_queue.queue.name
  event_bus_name = aws_cloudwatch_event_bus.bus.name

  # This is the pattern to catch all the events
  event_pattern = jsonencode({
    source = [{
      prefix = ""
    }]
  })
}

resource "aws_cloudwatch_event_target" "target" {
  event_bus_name = aws_cloudwatch_event_bus.bus.name

  rule = aws_cloudwatch_event_rule.rule.name
  arn  = aws_sqs_queue.queue.arn
}
