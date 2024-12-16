locals {
  eventbridge_rule_name = var.rule_name
}

resource "aws_cloudwatch_event_rule" "rule" {
  name = local.eventbridge_rule_name

  event_bus_name = var.event_bus_name
  event_pattern  = jsonencode(var.event_pattern)
}

module "event_targets" {
  source   = "../event_target"
  for_each = { for target in var.event_targets : "${target.target_name}" => target }

  eventbridge_bus_name = var.event_bus_name

  rule_name = aws_cloudwatch_event_rule.rule.name
  rule_arn  = aws_cloudwatch_event_rule.rule.arn

  target_name       = each.value.target_name
  config_envs       = each.value.config_envs
  data_bucket       = var.data_bucket
  credential_secret = var.credential_secret
}
