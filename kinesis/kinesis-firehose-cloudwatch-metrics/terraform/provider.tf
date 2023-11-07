locals {
  region = "us-east-1"
}

# variable "AWS_ACCESS_KEY_ID" {
#   type = string
# }

# variable "AWS_SECRET_ACCESS_KEY" {
#   type = string
# }

# variable "AWS_SESSION_TOKEN" {
#   type = string
# }

# This is the default provider
# The access credentials have the aws account information
# The access key needs to have sufficient permissions
provider "aws" {
  region = local.region
  # access_key = var.AWS_ACCESS_KEY_ID
  # secret_key = var.AWS_SECRET_ACCESS_KEY
  # token = var.AWS_SESSION_TOKEN
}
