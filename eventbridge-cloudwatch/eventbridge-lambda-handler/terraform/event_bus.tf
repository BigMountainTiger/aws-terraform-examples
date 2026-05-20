resource "aws_cloudwatch_event_bus" "bus" {
  name = "eventbridge-lmbdda-handler-example-bus"
}
