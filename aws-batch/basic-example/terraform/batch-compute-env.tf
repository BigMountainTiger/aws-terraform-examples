resource "aws_batch_compute_environment" "batch_example" {
  compute_environment_name = "${local.app_name}-compute-environment"

  compute_resources {
    max_vcpus = 1

    security_group_ids = [
      aws_vpc.vpc-example.default_security_group_id
    ]

    subnets = [
      aws_subnet.public-subnet-1.id,
      aws_subnet.public-subnet-2.id
    ]

    type = "FARGATE"
  }

  type         = "MANAGED"
  service_role = aws_iam_role.batch_service_role.arn

  # This is required to have a clean destroy
  # If the IAM policy is destroyed before the computation environment,
  # Terraform will not have sufficuent permissions to destroy the computation environment
  depends_on = [
    aws_iam_role_policy_attachment.batch_service_role
  ]
}
