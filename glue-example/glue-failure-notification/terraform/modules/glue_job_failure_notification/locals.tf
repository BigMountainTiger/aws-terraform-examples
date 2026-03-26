locals {
  eventbridge_rule_name = "simulated-glue-job-state-change"
  sqs_queue_name        = "example-sqs-queue"
  lambda_name           = "glue_job_failure_email_notification"
  lambda_timeout        = 60
  lambda_memory_size    = 256
}
