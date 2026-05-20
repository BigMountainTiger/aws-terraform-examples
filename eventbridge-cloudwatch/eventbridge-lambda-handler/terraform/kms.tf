resource "aws_kms_key" "common_kms_key" {
  description = "An example symmetric encryption KMS key"

  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"

  is_enabled              = true
  enable_key_rotation     = true
  deletion_window_in_days = 7
}

# The resource needs to be "*" for terraform to apply
resource "aws_kms_key_policy" "common_kms_key" {
  key_id = aws_kms_key.common_kms_key.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::${local.aws_account_id}:root"
          ]
        },
        Action   = "kms:*"
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_kms_alias" "common_kms_key" {
  name          = "alias/common_kms_key"
  target_key_id = aws_kms_key.common_kms_key.key_id
}
