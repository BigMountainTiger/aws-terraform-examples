variable "parameter_value" {
  type = object({
    host = optional(string, "db.host.com")
    user = optional(string, "db_user")
    pass = optional(string, "db_user")
  })
  default = {}
}
