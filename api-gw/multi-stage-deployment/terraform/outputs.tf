output "api_invocation_url" {
  value = {
    stage_1 = module.stage_1.api_invocation_url
    stage_2 = module.stage_2.api_invocation_url
  }
}

output "api_invocation_domain" {
  value = {
    stage_1 = "https://${module.stage_1.api_invocation_domain}/example"
    stage_2 = "https://${module.stage_2.api_invocation_domain}/example"
  }
}
