resource "aws_batch_job_queue" "batch_example" {
  name     = "${local.app_name}-job-queue"
  state    = "ENABLED"
  priority = 1

  compute_environments = [
    aws_batch_compute_environment.batch_example.arn
  ]
}
