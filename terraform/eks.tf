# EKS Cluster Configuration

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.1.5"

  name               = var.cluster_name
  kubernetes_version = var.cluster_version

  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.vpc.private_subnets
  endpoint_public_access = true

  eks_managed_node_groups = {
    main = {
      name = "main-node-group"

      instance_types = var.node_group_instance_types
      capacity_type  = "ON_DEMAND"

      min_size     = var.node_group_min_size
      max_size     = var.node_group_max_size
      desired_size = var.node_group_desired_size

      # Launch template configuration
      create_launch_template = false
      launch_template_name   = "eks-monitoring"

      disk_size = 50
      disk_type = "gp3"

      # Remote access cannot be specified with a launch template
      remote_access = {
        ec2_ssh_key               = null
        source_security_group_ids = []
      }

      # Ensure that irsa is enabled on the cluster, `enable_irsa = true`
      # and uncomment the serviceAccount annotation below
      k8s_labels = {
        Environment = var.environment
        NodeGroup   = "main"
      }

      update_config = {
        max_unavailable_percentage = 33 # or set `max_unavailable`
      }

      tags = var.tags
    }
  }

  tags = var.tags
}