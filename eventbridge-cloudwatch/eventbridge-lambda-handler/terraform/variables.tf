variable "example_event_integration" {
  type = object({
    rule_name = optional(string, "example-topic")
    event_pattern = optional(any, {
      detail-type = ["example-type"]
    })
    event_targets = list(object({
      target_name = string
      config_envs = optional(any, {})
    }))
  })
  default = {
    event_targets = [
      {
        target_name = "target-1"
        config_envs = {
          "parameter_1" : "value 1"
          "parameter_2" : "value 2"
        }
      },
      {
        target_name = "target-2"
      }
    ]
  }
}

