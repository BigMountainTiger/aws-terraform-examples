variable "rule_name" {
  type = string
}

variable "target_name" {
  type = string
}

variable "lambda_runtime" {
  type    = string
  default = "python3.11"
}

variable "sqs_arn" {
  type = string
}

variable "sqs_batch_window" {
  type    = number
  default = 300
}

variable "sqs_batch_size" {
  type    = number
  default = 100
}

variable "sqs_mapping_enabled" {
  type = bool
}

variable "config_envs" {
  type = any
}

variable "data_bucket" {
  type = string
}

variable "credential_secret" {
  type = string
}
