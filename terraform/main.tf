# EKS Monitoring Stack - Main Terraform Configuration

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
  }

  backend "s3" {
    # Backend configuration will be provided via backend config file
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "eks-monitoring-stack"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Data source for current AWS caller identity
data "aws_caller_identity" "current" {}