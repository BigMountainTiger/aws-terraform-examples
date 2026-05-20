# Use length to get the size of the list
output "module1_bucket_name" {
  value = length(module.bucket_1) > 0 ? module.bucket_1.count[0].bucket_name_created : ""
}
