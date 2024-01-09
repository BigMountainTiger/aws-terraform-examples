resource "aws_ssm_parameter" "parameter_with_default_tags" {
  name  = "parameter_with_default_tags"
  type  = "String"
  value = "The default tags will be added automatically"
}
