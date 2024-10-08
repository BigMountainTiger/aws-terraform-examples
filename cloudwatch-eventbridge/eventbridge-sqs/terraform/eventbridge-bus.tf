resource "aws_cloudwatch_event_bus" "bus" {
  name = "eventbridge-sqs-example-bus"
}
