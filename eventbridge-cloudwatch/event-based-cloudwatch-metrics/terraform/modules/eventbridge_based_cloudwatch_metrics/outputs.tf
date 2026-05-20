output "eventbridge_rule_name" {
  value = var.eventbridge_rule_name
}

output "cloudwatch_loggroup_name" {
  value = local.cloudwatch_loggroup_name
}

output "cloudwacth_metrics_namespace" {
  value = local.cloudwacth_metrics_namespace
}
