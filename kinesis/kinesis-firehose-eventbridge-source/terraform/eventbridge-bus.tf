resource "aws_cloudwatch_event_bus" "bus" {
  name = "kinesis-firehose-eventbridge-source"
}
