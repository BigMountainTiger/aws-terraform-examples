# "SUCCEEDED", "FAILED", "TIMEOUT", "STOPPED"
# "STOPPED" means the job was manually stopped. It is not an actual failure.

# Note: In real AWS Glue jobs, the source is "aws.glue",
# we can not put "aws.glue" as source through the AWS cli, so we use "song.example.glue" here for testing purpose.

# If the number of the jobs are not every large, we do not need to filter by jobName.

module "glue_job_state_change_metrics" {
  source = "./modules/glue_job_failure_notification"

  eventbridge_rule_pattern = jsonencode({
    "source" : ["song.example.glue"],
    "detail-type" : ["Glue Job State Change"],
    "detail" : {
      "state" : ["FAILED", "TIMEOUT"],
      "jobName" : [
        { "wildcard" : "simulated-glue-job-*" },
        { "wildcard" : "simulated-*" }
      ]
    }
  })
}
