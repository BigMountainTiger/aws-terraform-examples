resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.a_simple_cluster.name
  node_group_name = "node_group_1"
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = [local.public-1, local.public-2]
  instance_types  = ["t2.micro"]

  scaling_config {
    min_size     = 1
    max_size     = 3
    desired_size = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
