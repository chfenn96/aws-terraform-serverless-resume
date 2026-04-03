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
  region = var.region # CloudFront requires us-east-1 for certain features
}

# 2. Create the S3 Bucket (Storage)
resource "aws_s3_bucket" "website_bucket" {
  bucket = "${var.bucket_name_prefix}-${random_id.id.hex}"
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

# 7. Create the DynamoDB Table (The Database)
resource "aws_dynamodb_table" "visitor_count" {
  name           = var.dynamodb_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S" # "S" stands for String
  }
}

# 8. Seed the initial record into DynamoDB
resource "aws_dynamodb_table_item" "init_count" {
  table_name = aws_dynamodb_table.visitor_count.name
  hash_key   = aws_dynamodb_table.visitor_count.hash_key

  item = jsonencode({
    "id":    {"S": "visitors"},
    "count": {"N": "0"}
  })
}

# 9. Archive the Python code (Zip the app.py)
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "../backend/app.py"
  output_path = "lambda_function.zip"
}

# 10. IAM Role for Lambda
resource "aws_iam_role" "iam_for_lambda" {
  name = "cloud_resume_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# 11. IAM Policy for DynamoDB Access
resource "aws_iam_role_policy" "lambda_dynamo_policy" {
  name = "lambda_dynamo_policy"
  role = aws_iam_role.iam_for_lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["dynamodb:GetItem", "dynamodb:UpdateItem"]
      Resource = aws_dynamodb_table.visitor_count.arn
    }]
  })
}

# 12. Create the Lambda Function
resource "aws_lambda_function" "visitor_counter" {
  filename      = "lambda_function.zip"
  function_name = "visitor_counter_func"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "app.lambda_handler" # File name is app, function is lambda_handler
  runtime       = "python3.12"

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.visitor_count.name
    }
  }
}

# 13. API Gateway (HTTP API)
resource "aws_apigatewayv2_api" "http_api" {
  name          = "visitor_counter_api"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["*"] # We will lock this down to your domain later
    allow_methods = ["GET"]
    allow_headers = ["content-type"]
  }
}

# 14. API Gateway Integration with Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.visitor_counter.invoke_arn
}

# 15. API Gateway Route
resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# 16. API Gateway Stage (Automated Deployment)
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

# 17. Permission for API Gateway to call Lambda
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.visitor_counter.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}