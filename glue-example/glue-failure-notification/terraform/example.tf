locals {
  eventbridge_rule_name = "simulated-glue-job-state-change"
}

module "glue_job_state_change_metrics" {
  source = "./modules/glue_job_failure_notification"

  eventbridge_rule_name = local.eventbridge_rule_name
  eventbridge_rule_pattern = jsonencode({
    # we can not put "aws.glue" as source through the AWS cli
    "source" : ["song.example.glue"],
    "detail-type" : ["Glue Job State Change"],
    "detail" : {
      "state" : ["SUCCEEDED", "FAILED", "TIMEOUT", "STOPPED"]
    }
  })
}
