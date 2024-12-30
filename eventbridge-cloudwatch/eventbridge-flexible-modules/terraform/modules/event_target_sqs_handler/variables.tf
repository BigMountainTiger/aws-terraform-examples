variable "environment" {
  type = string
}

variable "sqs_name" {
  type = string
}

variable "sqs_arn" {
  type = string
}

variable "sqs_mapping_enabled" {
  type = bool
}

variable "lambda_runtime" {
  type    = string
  default = "python3.11"
}

variable "lambda_memory_size" {
  type    = number
  default = 1024
}

variable "lambda_timeout" {
  type    = number
  default = 900
}

variable "sqs_batch_window" {
  type    = number
  default = 300
}

variable "sqs_batch_size" {
  type    = number
  default = 100
}

variable "lambda_layers_deployed" {
  type    = bool
  default = false
}

variable "lambda_config_envs" {
  type    = any
  default = {}
}
