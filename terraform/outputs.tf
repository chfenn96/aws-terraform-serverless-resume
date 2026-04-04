output "website_url" {
  description = "The public URL of the CloudFront distribution"
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "bucket_name" {
  description = "The name of the S3 bucket hosting the resume"
  value       = aws_s3_bucket.website_bucket.id
}

output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.s3_distribution.id
}

output "dynamodb_table_name" {
  description = "The name of the vistor count DynamoDB table"
  value       = aws_dynamodb_table.visitor_count.name
}

output "api_url" {
  description = "The Invoke URL for the API Gateway"
  value       = aws_apigatewayv2_api.http_api.api_endpoint
}

output "state_bucket_name" {
  description = "The name of the S3 bucket used for Terraform remote state storage. (Hardening Phase)."
  value       = aws_s3_bucket.terraform_state.id
}

output "github_actions_role_arn" {
  description = "The ARN of the IAM Role for GitHub Actions OIDC"
  value       = aws_iam_role.github_actions_role.arn
}