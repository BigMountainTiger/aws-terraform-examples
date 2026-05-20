# Subnet group
resource "aws_dms_replication_subnet_group" "subnet_group" {
  replication_subnet_group_description = "${local.app_name} DMS subnet group"
  replication_subnet_group_id          = "${local.app_name}-dms-replication-subnet-group"

  subnet_ids = [
    aws_subnet.public-subnet-1.id,
    aws_subnet.public-subnet-2.id
  ]

  tags = {
    Name = "${local.app_name}-dms-subnet-group"
  }
}

# IAM roles
data "aws_iam_policy_document" "dms_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["dms.amazonaws.com"]
      type        = "Service"
    }
  }
}

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

# Replication configuration
resource "aws_dms_replication_config" "serverless_config" {
  resource_identifier           = "DMS-config"
  replication_config_identifier = "DMS-config"
  replication_type              = "full-load-and-cdc"

  source_endpoint_arn = aws_dms_endpoint.postgres_source.endpoint_arn
  target_endpoint_arn = aws_dms_endpoint.postgres_target.endpoint_arn

  # Do not start replication
  start_replication = false

  table_mappings = jsonencode({
    "rules" : [
      {
        "rule-id" : "1",
        "rule-name" : "1",
        "rule-type" : "selection",
        "object-locator" : {
          "schema-name" : "public",
          "table-name" : "example"
        },
        "rule-action" : "include"
      },
      {
        "rule-id" : "2",
        "rule-name" : "2",
        "rule-type" : "transformation",
        "rule-action" : "rename",
        "rule-target" : "table",
        "object-locator" : {
          "schema-name" : "public",
          "table-name" : "example"
        },
        "value" : "example_target"
      }
    ]
  })

  # capacity 2 is the minumum
  compute_config {
    replication_subnet_group_id = aws_dms_replication_subnet_group.subnet_group.replication_subnet_group_id
    max_capacity_units          = "2"
    min_capacity_units          = "2"
  }
}
