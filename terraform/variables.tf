# Variables for EKS Monitoring Stack

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-monitoring-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.28"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "node_group_instance_types" {
  description = "Instance types for EKS node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_group_desired_size" {
  description = "Desired number of nodes in the node group"
  type        = number
  default     = 2
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in the node group"
  type        = number
  default     = 4
}

variable "node_group_min_size" {
  description = "Minimum number of nodes in the node group"
  type        = number
  default     = 1
}

variable "enable_irsa" {
  description = "Enable IAM Roles for Service Accounts"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}