variable "event_bus_name" {
  type = string
}

variable "rule_name" {
  type = string
}

variable "rule_arn" {
  type = string
}

variable "target_purpose" {
  type = string
}

variable "message_retention_seconds" {
  type    = number
  default = 1209600
}

variable "visibility_timeout_seconds" {
  type    = number
  default = 1800
}
