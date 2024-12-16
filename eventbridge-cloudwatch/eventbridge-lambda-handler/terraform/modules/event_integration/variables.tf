variable "event_bus_name" {
  type = string
}

variable "rule_name" {
  type = string
}

variable "event_pattern" {
  type = any
}

variable "event_targets" {
  type = list(object({
    target_name = string
    config_envs = any
  }))
}

variable "data_bucket" {
  type = string
}

variable "credential_secret" {
  type = string
}
