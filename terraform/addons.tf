# EKS Add-ons Configuration

# EBS CSI Driver Add-on
resource "aws_eks_addon" "ebs_csi" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.24.0-eksbuild.1"
  service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn

  depends_on = [
    module.eks.eks_managed_node_groups,
  ]

  tags = var.tags
}

# VPC CNI Add-on
resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "vpc-cni"
  addon_version = "v1.15.1-eksbuild.1"
  depends_on = [
    module.eks.eks_managed_node_groups,
  ]

  tags = var.tags
}

# CoreDNS Add-on
resource "aws_eks_addon" "coredns" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "coredns"
  addon_version = "v1.10.1-eksbuild.5"

  depends_on = [
    module.eks.eks_managed_node_groups,
  ]

  tags = var.tags
}

# kube-proxy Add-on
resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "kube-proxy"
  addon_version = "v1.33.2-eksbuild.2"

  depends_on = [
    module.eks.eks_managed_node_groups,
  ]

  tags = var.tags
}