module "all_event_integration" {
  source = "./modules/event_rule"

  event_bus_name = aws_cloudwatch_event_bus.bus.name
  rule_name      = "all_event_integration"

  event_pattern = {
    "source" : [{
      "prefix" : ""
    }]
  }
}

module "all_event_integration_default" {
  source = "./modules/event_target_sqs"

  target_purpose = "default"
  event_bus_name = aws_cloudwatch_event_bus.bus.name
  rule_arn       = module.all_event_integration.rule_arn
  rule_name      = module.all_event_integration.rule_name
}