data "aws_s3_bucket" "s3" {
  bucket = local.bucket
}

resource "aws_cloudfront_origin_access_identity" "s3" {
  comment = "cloudfront_access"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${data.aws_s3_bucket.s3.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.s3.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "s3" {
  bucket = data.aws_s3_bucket.s3.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

locals {
  deploy_cloudfront = false
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  count = local.deploy_cloudfront ? 1 : 0

  origin {
    domain_name = data.aws_s3_bucket.s3.bucket_regional_domain_name
    origin_id   = data.aws_s3_bucket.s3.bucket

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.s3.cloudfront_access_identity_path
    }
  }

  enabled             = true
  price_class         = "PriceClass_100"
  default_root_object = "index.html"

  aliases = [local.swagger_domain_name]

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
    target_origin_id = data.aws_s3_bucket.s3.bucket
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]

    viewer_protocol_policy = "https-only"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    # seconds
    min_ttl     = 60
    default_ttl = 60
    max_ttl     = 60
  }

  tags = {
    Refresh = "Deployed at ${timestamp()}"
  }
}
