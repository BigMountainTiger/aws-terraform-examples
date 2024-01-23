output "api_invocation_url" {
  value = aws_api_gateway_stage.stage.invoke_url
}

output "api_invocation_domain" {
  value = local.www_domain_name
}