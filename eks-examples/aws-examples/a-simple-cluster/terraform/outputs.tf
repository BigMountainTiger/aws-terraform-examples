output "endpoint" {
  value = aws_eks_cluster.a_simple_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.a_simple_cluster.certificate_authority[0].data
}

output "service_account_role_arn" {
  value = aws_iam_role.service_account.arn
}

output "cluster_openid_provider" {
  value = aws_eks_cluster.a_simple_cluster.identity
}

