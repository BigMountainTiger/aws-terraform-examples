resource "aws_cloudwatch_event_rule" "rule" {
  name = var.rule_name

  event_bus_name = var.event_bus_name
  event_pattern  = jsonencode(var.event_pattern)
}

output "rule_name" {
  value = aws_cloudwatch_event_rule.rule.name
}

output "rule_arn" {
  value = aws_cloudwatch_event_rule.rule.arn
}
