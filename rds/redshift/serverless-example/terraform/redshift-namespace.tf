locals {
  workgroup_name      = "default-workgroup"
  namespace_name      = "default-namespace"
  admin_username      = "redshift"
  admin_user_password = "Pwd-1234"
}

resource "aws_redshiftserverless_namespace" "namespace" {
  namespace_name = local.namespace_name

  admin_username      = local.admin_username
  admin_user_password = local.admin_user_password
  db_name             = "public"

  iam_roles = [
    aws_iam_role.redshift_s3_access.arn
  ]

  default_iam_role_arn = aws_iam_role.redshift_s3_access.arn
}

