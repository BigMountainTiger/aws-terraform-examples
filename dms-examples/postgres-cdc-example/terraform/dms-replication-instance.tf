# https://registry.terraform.io/providers/rgeraskin/aws2/latest/docs/resources/dms_replication_instance
# Need the following IAM roles
# dms-vpc-role
# dms-cloudwatch-logs-role
# dms-access-for-endpoint

data "aws_iam_policy_document" "dms_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["dms.amazonaws.com"]
      type        = "Service"
    }
  }
}

# resource "aws_iam_role" "dms-access-for-endpoint" {
#   name               = "dms-access-for-endpoint"
#   assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
# }

# resource "aws_iam_role_policy_attachment" "dms-access-for-endpoint-AmazonDMSRedshiftS3Role" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSRedshiftS3Role"
#   role       = aws_iam_role.dms-access-for-endpoint.name
# }

resource "aws_iam_role" "dms-cloudwatch-logs-role" {
  name               = "dms-cloudwatch-logs-role"
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
}

resource "aws_iam_role_policy_attachment" "dms-cloudwatch-logs-role-AmazonDMSCloudWatchLogsRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSCloudWatchLogsRole"
  role       = aws_iam_role.dms-cloudwatch-logs-role.name
}

resource "aws_iam_role" "dms-vpc-role" {
  name               = "dms-vpc-role"
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
}

resource "aws_iam_role_policy_attachment" "dms-vpc-role-AmazonDMSVPCManagementRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
  role       = aws_iam_role.dms-vpc-role.name
}

resource "aws_dms_replication_subnet_group" "subnet_group" {
  replication_subnet_group_description = "${local.app_name} subnet group"
  replication_subnet_group_id          = "${local.app_name}-dms-replication-subnet-group"

  subnet_ids = [
    aws_subnet.public-subnet-1.id,
    aws_subnet.public-subnet-2.id
  ]

  tags = {
    Name = "${local.app_name}-subnet-group"
  }

  depends_on = [
    aws_iam_role.dms-vpc-role,
    # aws_iam_role.dms-access-for-endpoint,
    aws_iam_role.dms-cloudwatch-logs-role
  ]
}

resource "aws_dms_replication_instance" "dms_example" {
  replication_instance_id    = "${local.app_name}-replication-instance"
  replication_instance_class = "dms.t3.micro"
  allocated_storage          = 20
  engine_version             = "3.5.1"
  multi_az                   = false
  auto_minor_version_upgrade = true
  publicly_accessible        = true
  apply_immediately          = true

  replication_subnet_group_id = aws_dms_replication_subnet_group.subnet_group.id

  tags = {
    Name = local.app_name
  }

  vpc_security_group_ids = [
    aws_default_security_group.default-sg.id
  ]

  depends_on = [
    aws_dms_replication_subnet_group.subnet_group
  ]
}
