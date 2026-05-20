locals {
  eventbridge_rule_name        = var.eventbridge_rule_name
  cloudwatch_loggroup_name     = "/aws/events/${var.eventbridge_rule_name}"
  cloudwacth_metrics_namespace = var.eventbridge_rule_name
}

resource "aws_cloudwatch_log_group" "target_loggroup" {
  name              = local.cloudwatch_loggroup_name
  retention_in_days = var.cloudwatch_loggroup_retention_in_days
}

resource "aws_cloudwatch_log_metric_filter" "metric_filter" {
  for_each = { for metric in var.cloudwacth_metrics.metrics : "${metric.name}" => metric }

  log_group_name = aws_cloudwatch_log_group.target_loggroup.name
  name           = each.value.name
  pattern        = each.value.pattern

  metric_transformation {
    name       = each.value.name
    namespace  = local.cloudwacth_metrics_namespace
    value      = each.value.metric_transformation.value
    unit       = each.value.metric_transformation.unit
    dimensions = each.value.metric_transformation.dimensions
  }
}

resource "aws_cloudwatch_event_rule" "event_rule" {
  name          = local.eventbridge_rule_name
  event_pattern = var.eventbridge_rule_pattern

  force_destroy = true
}

resource "aws_cloudwatch_event_target" "event_target" {
  rule = aws_cloudwatch_event_rule.event_rule.name
  arn  = aws_cloudwatch_log_group.target_loggroup.arn

  depends_on = [
    aws_cloudwatch_log_group.target_loggroup
  ]
}
