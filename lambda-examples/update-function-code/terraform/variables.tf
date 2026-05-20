variable "lambda_runtime_config" {
  type = object({
    update_runtime_on : string,
    qualifier : string,
    runtime_version_arn : string
  })
  default = {
    update_runtime_on   = "FunctionUpdate",
    qualifier           = null,
    runtime_version_arn = null
  }
  validation {
    condition     = contains(["Manual", "FunctionUpdate", "Auto"], var.lambda_runtime_config.update_runtime_on)
    error_message = "update_runtime_on must be Manual, FunctionUpdate, or Auto"
  }
}
