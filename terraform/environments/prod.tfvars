# Production Environment Configuration

aws_region      = "us-east-1"
environment     = "prod"
cluster_name    = "eks-monitoring"
cluster_version = "1.28"

vpc_cidr = "10.0.0.0/16"

node_group_instance_types = ["t3.medium"]
node_group_desired_size   = 2
node_group_max_size       = 4
node_group_min_size       = 1

enable_irsa = true

tags = {
  Environment = "prod"
  Project     = "eks-monitoring-stack"
}