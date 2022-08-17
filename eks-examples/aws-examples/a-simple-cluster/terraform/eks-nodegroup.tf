resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.a_simple_cluster.name
  node_group_name = "node_group_1"
  node_role_arn   = aws_iam_role.node_group.arn
  instance_types  = ["t2.micro"]
  disk_size       = 20

  subnet_ids = local.public-subnets

  scaling_config {
    min_size     = 1
    max_size     = 5
    desired_size = 4
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
