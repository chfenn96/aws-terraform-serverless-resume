# 1. Specify the Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # CloudFront requires us-east-1 for certain features
}

# 2. Create the S3 Bucket (Storage)
resource "aws_s3_bucket" "website_bucket" {
  bucket = "my-cloud-resume-bucket-${random_id.id.hex}" # Must be globally unique
}

resource "random_id" "id" {
  byte_length = 4
}

# 3. Block all public access to the bucket (Security Best Practice)
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket                  = aws_s3_bucket.website_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 4. Create CloudFront Origin Access Control (The "Key" for CloudFront to enter S3)
resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "s3-access-control"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# 5. Create the CloudFront Distribution (The "URL" Generator)
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = "S3Origin"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3Origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# 6. S3 Bucket Policy (Allows CloudFront to read your files)
resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = {
      Sid       = "AllowCloudFrontServicePrincipalReadOnly"
      Effect    = "Allow"
      Principal = { Service = "cloudfront.amazonaws.com" }
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
        }
      }
    }
  })
}

# 7. Output the URL
output "website_url" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

# 8. Output the Bucket
output "bucket_name" {
  value = aws_s3_bucket.website_bucket.id
}