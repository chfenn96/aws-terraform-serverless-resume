variable "bucket_name_prefix" {
  description = "The prefix for the S3 bucket"
  type        = string
  default     = "my-cloud-resume-bucket"
}

variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  type        = string
  default     = "VisitorCount"
}

variable "state_bucket_prefix" {
  description = "Prefix for the S3 bucket used for Terraform state"
  type        = string
  default     = "terraform-state"
}

variable "state_lock_table_name" {
  description = "Name of the DynamoDB table for Terraform state locking"
  type        = string
  default     = "terraform-state-locking"
}