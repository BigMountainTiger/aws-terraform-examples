resource "aws_db_subnet_group" "aurora" {
  name = "aurora_secret_rotation_example_subnet_group"
  subnet_ids = [
    aws_subnet.public-subnet-1.id,
    aws_subnet.public-subnet-2.id
  ]

  tags = {
    Name = "aurora_secret_rotation_example_subnet_group"
  }
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier = "aurora-cluster"
  engine             = "aurora-postgresql"
  engine_version     = "15.2"
  engine_mode        = "provisioned"

  database_name               = "postgres"
  master_username             = "postgres"
  manage_master_user_password = true

  db_subnet_group_name = aws_db_subnet_group.aurora.name
  skip_final_snapshot  = true

  serverlessv2_scaling_configuration {
    max_capacity = 1.0
    min_capacity = 0.5
  }

}

resource "aws_rds_cluster_instance" "aurora" {
  cluster_identifier  = aws_rds_cluster.aurora.id
  instance_class      = "db.serverless"
  publicly_accessible = true
  engine              = aws_rds_cluster.aurora.engine
  engine_version      = aws_rds_cluster.aurora.engine_version
}

resource "null_resource" "ratation-90-days" {

  provisioner "local-exec" {
    command = <<EOT
      aws secretsmanager rotate-secret \
      --secret-id ${aws_rds_cluster.aurora.master_user_secret[0].secret_arn} \
      --rotation-rules AutomaticallyAfterDays=90
    EOT
  }

  depends_on = [
    aws_rds_cluster.aurora,
    aws_rds_cluster_instance.aurora
  ]
}
