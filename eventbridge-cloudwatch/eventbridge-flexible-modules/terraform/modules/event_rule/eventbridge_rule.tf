resource "aws_cloudwatch_event_rule" "rule" {
  name = "${var.rule_name}-${var.environment}"

  event_bus_name = var.event_bus_name
  event_pattern  = jsonencode(var.event_pattern)
}
