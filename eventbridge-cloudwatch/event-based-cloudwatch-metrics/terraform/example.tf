locals {
  eventbridge_rule_name = "simulated-glue-job-state-change"
}

module "glue_job_state_change_metrics" {
  source = "./modules/eventbridge_based_cloudwatch_metrics"

  eventbridge_rule_name = local.eventbridge_rule_name
  eventbridge_rule_pattern = jsonencode({
    # we can not put "aws.glue" as source through the AWS cli
    "source" : ["song.example.glue"],
    "detail-type" : ["Glue Job State Change"],
    "detail" : {
      "state" : ["SUCCEEDED", "FAILED", "TIMEOUT", "STOPPED"]
    }
  })

  cloudwatch_loggroup_retention_in_days = 14
  cloudwacth_metrics = {
    metrics = [
      {
        name    = "SUCCEEDED"
        pattern = <<PATTERN
          {$.detail.jobName = "*" && $.detail.state = "SUCCEEDED"}
        PATTERN
        metric_transformation = {
          value = "1"
          dimensions = {
            jobName = "$.detail.jobName"
          }
        }
      },
      {
        name    = "FAILED"
        pattern = <<PATTERN
          {$.detail.jobName = "*" && $.detail.state = "FAILED"}
        PATTERN
        metric_transformation = {
          value = "1"
          dimensions = {
            jobName = "$.detail.jobName"
          }
        }
      },
      {
        name    = "TIMEOUT"
        pattern = <<PATTERN
          {$.detail.jobName = "*" && $.detail.state = "TIMEOUT"}
        PATTERN
        metric_transformation = {
          value = "1"
          dimensions = {
            jobName = "$.detail.jobName"
          }
        }
      },
      {
        name    = "STOPPED"
        pattern = <<PATTERN
          {$.detail.jobName = "*" && $.detail.state = "STOPPED"}
        PATTERN
        metric_transformation = {
          value = "1"
          dimensions = {
            jobName = "$.detail.jobName"
          }
        }
      }
    ]
  }
}
