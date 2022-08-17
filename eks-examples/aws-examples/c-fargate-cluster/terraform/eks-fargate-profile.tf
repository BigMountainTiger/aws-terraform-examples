resource "aws_eks_fargate_profile" "test-fargate" {
  cluster_name           = aws_eks_cluster.a_simple_cluster.name
  fargate_profile_name   = "test-fargate-profile"
  pod_execution_role_arn = aws_iam_role.eks_pod_execution_role.arn
  subnet_ids             = [local.private-1, local.private-2]

  selector {
    namespace = "test-fargate"
  }
}
