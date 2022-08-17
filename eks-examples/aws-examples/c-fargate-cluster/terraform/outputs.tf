output "pod_execution_role_arn" {
  value = aws_iam_role.eks_pod_execution_role.arn
}

output "subnet-ids" {
  value = {
    public-1 = local.public-1
    public-2 = local.public-2
    private-1 = local.private-1
    private-2 = local.private-2
  }
}