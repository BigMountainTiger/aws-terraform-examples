module "event_integration_example" {
  source = "./modules/event_integration"

  event_bus_name = aws_cloudwatch_event_bus.bus.name

  rule_name         = var.example_event_integration.rule_name
  event_pattern     = var.example_event_integration.event_pattern
  event_targets     = var.example_event_integration.event_targets
  data_bucket       = aws_s3_bucket.data_bucket.bucket
  credential_secret = aws_secretsmanager_secret.secret.name

  depends_on = [
    aws_cloudwatch_event_bus.bus
  ]
}
