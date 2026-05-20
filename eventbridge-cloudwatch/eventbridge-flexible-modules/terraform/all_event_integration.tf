module "all_event_rule" {
  source      = "./modules/event_rule"
  environment = var.environment

  event_bus_name = aws_cloudwatch_event_bus.bus.name

  rule_name     = var.all_event_rule.name
  event_pattern = var.all_event_rule.event_pattern
}

module "all_event_rule_default" {
  source      = "./modules/event_target_sqs"
  environment = var.environment

  event_bus_name = aws_cloudwatch_event_bus.bus.name
  rule_name      = module.all_event_rule.rule_name
  rule_arn       = module.all_event_rule.rule_arn

  target_purpose = var.all_event_rule_default.target_purpose
}

module "all_event_rule_default_handler" {
  source      = "./modules/event_target_sqs_handler"
  environment = var.environment

  sqs_name = module.all_event_rule_default.sqs_name
  sqs_arn  = module.all_event_rule_default.sqs_arn

  lambda_memory_size = var.all_event_rule_default_handler.lambda_memory_size
  lambda_timeout     = var.all_event_rule_default_handler.lambda_timeout

  # Layers deployed
  lambda_layers_deployed = false

  lambda_config_envs = merge(
    {
      BUCKET_NAME                = "bucket_name"
      API_CREDENTIAL_SECRET_NAME = "secret_name"
    },
    var.all_event_rule_default_handler.lambda_config_envs
  )

  sqs_batch_window    = var.all_event_rule_default_handler.sqs_batch_window
  sqs_batch_size      = var.all_event_rule_default_handler.sqs_batch_size
  sqs_mapping_enabled = var.all_event_rule_default_handler.sqs_mapping_enabled
}
