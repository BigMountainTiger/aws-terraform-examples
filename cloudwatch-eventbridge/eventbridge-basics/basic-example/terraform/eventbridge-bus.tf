locals {
  event_bus_name = "example-event-bus"
}

resource "aws_cloudwatch_event_bus" "bus" {
  name = local.event_bus_name
}