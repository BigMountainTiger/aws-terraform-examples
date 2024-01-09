resource "aws_ssm_parameter" "parameter_with_tags_all_section" {
  name  = "parameter_with_tags_all_section"
  type  = "String"
  value = "It looks like tags_all ignored totally?"

  # Only the default tags applied, anything added here has no effect
  tags_all = {
    "name" = "parameter_with_tags_all_section"
  }
}
