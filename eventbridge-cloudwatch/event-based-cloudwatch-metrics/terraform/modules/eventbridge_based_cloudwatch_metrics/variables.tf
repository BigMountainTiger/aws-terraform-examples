variable "eventbridge_rule_name" {
  type = string
}

variable "eventbridge_rule_pattern" {
  type = string
}

variable "cloudwatch_loggroup_retention_in_days" {
  type    = number
  default = 14
}

variable "cloudwacth_metrics" {
  type = object({
    metrics = list(object({
      name    = string
      pattern = string

      metric_transformation = object({
        value      = optional(string, "1")
        unit       = optional(string, null)
        dimensions = optional(any, null)
      }) })
    )
  })
}
