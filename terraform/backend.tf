# Terraform Backend Configuration
# This file defines the S3 backend configuration for Terraform state management

# S3 bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = "akolbin-eks-monitoring-terraform-state"

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 bucket public access block
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = "akolbin-eks-monitoring-terraform-state"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}