output "s3_bucket" {
  value = aws_s3_bucket.s3.bucket
}
output "cloudfront" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}

output "domain" {
  value = aws_route53_record.cname_route53_record.name
}
