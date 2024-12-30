variable "environment" {
  type    = string
  default = "sbx"
}

variable "all_event_rule" {
  type = object({
    name = optional(string, "all-event")
    event_pattern = optional(any, {
      "source" : [{
        "prefix" : ""
      }]
    })
  })
  default = {}
}

variable "all_event_rule_default" {
  type = object({
    target_purpose = optional(string, "default")
  })
  default = {}
}

variable "all_event_rule_default_handler" {
  type = object({
    lambda_memory_size  = optional(number, 1024)
    lambda_timeout      = optional(number, 900)
    lambda_config_envs  = optional(any, {})
    sqs_batch_window    = optional(number, 300)
    sqs_batch_size      = optional(number, 100)
    sqs_mapping_enabled = optional(bool, false)
  })
  default = {
    sqs_mapping_enabled = true
  }
}
