resource "aws_eks_cluster" "a_simple_cluster" {
  name     = "a_simple_cluster"
  version  = "1.24"
  role_arn = aws_iam_role.eks_cluter_role.arn

  vpc_config {
    subnet_ids = [local.public-1, local.public-2]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]
}
