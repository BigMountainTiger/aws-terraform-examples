variable "job_configure" {
  type = object({
    schedule         = optional(string, "default schedule")
    email_recipients = optional(string, "")
  })
  default = {}
}
