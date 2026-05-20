# The container_properties
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/batch_job_definition
# https://docs.aws.amazon.com/batch/latest/APIReference/API_RegisterJobDefinition.html

resource "aws_batch_job_definition" "batch_example" {
  name = "${local.app_name}-job-definition"
  type = "container"

  platform_capabilities = [
    "FARGATE",
  ]

  container_properties = jsonencode({
    image      = "${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/aws-batch-example:basic-example"
    jobRoleArn = aws_iam_role.task_role.arn

    fargatePlatformConfiguration = {
      platformVersion = "LATEST"
    }

    networkConfiguration = {
      assignPublicIp = "ENABLED"
    }

    resourceRequirements = [
      {
        type  = "VCPU"
        value = "0.25"
      },
      {
        type  = "MEMORY"
        value = "512"
      }
    ]

    executionRoleArn = aws_iam_role.task_execution_role.arn
  })
}
