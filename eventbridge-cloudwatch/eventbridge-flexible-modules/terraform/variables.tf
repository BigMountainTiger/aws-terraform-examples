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
