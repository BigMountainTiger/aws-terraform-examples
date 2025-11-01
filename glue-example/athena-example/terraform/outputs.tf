output "s3_bucket_name" {
  value = aws_s3_bucket.s3.id
}

output "glue_database_name" {
  value = aws_glue_catalog_database.athena_example_database.name
}

output "athena_workgroup_name" {
  value = aws_athena_workgroup.workgroup.name
}
