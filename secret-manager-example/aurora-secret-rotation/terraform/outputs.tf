output "aurora-cluster-arn" {
  value = aws_rds_cluster.aurora.arn
}

output "secret-arn" {
  value = aws_rds_cluster.aurora.master_user_secret[0].secret_arn
}

output "endpoint" {
  value = aws_rds_cluster.aurora.endpoint
}
