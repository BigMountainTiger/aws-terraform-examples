variable "eventbridge_bus_name" {
  type = string
}

variable "rule_name" {
  type = string
}

variable "rule_arn" {
  type = string
}

variable "target_name" {
  type = string
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