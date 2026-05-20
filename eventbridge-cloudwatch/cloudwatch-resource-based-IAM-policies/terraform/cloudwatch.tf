locals {
  event_name               = "exmaple-eventbridge-event"
  cloudwatch_loggroup_name = "/aws/events/${local.event_name}"
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = local.cloudwatch_loggroup_name
  retention_in_days = 14
}
