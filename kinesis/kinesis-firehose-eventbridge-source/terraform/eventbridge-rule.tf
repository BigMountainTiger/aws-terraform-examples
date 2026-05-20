resource "aws_cloudwatch_event_rule" "firehose" {
  name           = "firehose_rule"
  event_bus_name = aws_cloudwatch_event_bus.bus.name

  event_pattern = jsonencode({
    source = [{
      prefix = ""
    }]
  })
}

resource "aws_cloudwatch_event_target" "firehose" {

  event_bus_name = aws_cloudwatch_event_bus.bus.name

  rule     = aws_cloudwatch_event_rule.firehose.name
  arn      = aws_kinesis_firehose_delivery_stream.s3.arn
  role_arn = aws_iam_role.event_rule.arn
}
