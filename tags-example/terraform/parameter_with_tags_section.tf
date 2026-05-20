resource "aws_ssm_parameter" "parameter_with_tags_section" {
  name  = "parameter_with_tags_section"
  type  = "String"
  value = "Add additional tags by the tags field"

  tags = {
    "name" = "parameter_with_tags_section"
  }
}