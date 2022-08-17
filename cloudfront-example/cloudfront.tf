resource "aws_cloudfront_origin_access_identity" "cloudfront_access" {
  comment = "Example cloudfront_access"
}

data "aws_acm_certificate" "acm_certificate" {
  domain      = local.domain_name
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.s3.bucket_regional_domain_name
    origin_id   = local.s3_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront_access.cloudfront_access_identity_path
    }
  }

  enabled             = true
  price_class         = "PriceClass_100"
  default_root_object = "index.htm"

  aliases = [local.domain_name]

  viewer_certificate {
    acm_certificate_arn            = data.aws_acm_certificate.acm_certificate.arn
    cloudfront_default_certificate = false
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1"
  }


  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US"]
    }
  }

  default_cache_behavior {
    target_origin_id = local.s3_name
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]

    viewer_protocol_policy = "https-only"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 86400
    default_ttl = 86400
    max_ttl     = 86400
  }
}
