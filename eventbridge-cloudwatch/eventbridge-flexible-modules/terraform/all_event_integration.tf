module "all_event_rule" {
  source = "./modules/event_rule"

  event_bus_name = aws_cloudwatch_event_bus.bus.name
  rule_name      = var.all_event_rule.name
  event_pattern  = var.all_event_rule.event_pattern
}

module "all_event_rule_default" {
  source = "./modules/event_target_sqs"

  event_bus_name = aws_cloudwatch_event_bus.bus.name
  rule_arn       = module.all_event_rule.rule_arn
  rule_name      = module.all_event_rule.rule_name

  target_purpose = var.all_event_rule_default.target_purpose
}
