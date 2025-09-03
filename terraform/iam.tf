# IAM Roles and Policies for EKS Monitoring Stack

# EBS CSI Driver IAM Role
module "ebs_csi_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.28.0"

  role_name             = "${var.cluster_name}-ebs-csi-driver"
  attach_ebs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = var.tags
}

# Fluent Bit IAM Role
module "fluent_bit_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.28.0"

  role_name = "${var.cluster_name}-fluent-bit"

  role_policy_arns = {
    CloudWatchAgentServerPolicy = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  }

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["logging:fluent-bit"]
    }
  }

  tags = var.tags
}

# Additional policy for Fluent Bit S3 access
resource "aws_iam_policy" "fluent_bit_s3" {
  name        = "${var.cluster_name}-fluent-bit-s3"
  description = "IAM policy for Fluent Bit S3 access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.cluster_name}-logs-*",
          "arn:aws:s3:::${var.cluster_name}-logs-*/*"
        ]
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "fluent_bit_s3" {
  policy_arn = aws_iam_policy.fluent_bit_s3.arn
  role       = module.fluent_bit_irsa_role.iam_role_name
}

# Prometheus IAM Role for CloudWatch integration
module "prometheus_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.28.0"

  role_name = "${var.cluster_name}-prometheus"

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["monitoring:prometheus-server"]
    }
  }

  tags = var.tags
}

# CloudWatch read-only policy for Prometheus
resource "aws_iam_policy" "prometheus_cloudwatch" {
  name        = "${var.cluster_name}-prometheus-cloudwatch"
  description = "IAM policy for Prometheus CloudWatch access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:GetMetricData",
          "cloudwatch:ListMetrics",
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "tag:GetResources"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "prometheus_cloudwatch" {
  policy_arn = aws_iam_policy.prometheus_cloudwatch.arn
  role       = module.prometheus_irsa_role.iam_role_name
}

# Grafana IAM Role
module "grafana_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.28.0"

  role_name = "${var.cluster_name}-grafana"

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["monitoring:grafana"]
    }
  }

  tags = var.tags
}

# CloudWatch read-only policy for Grafana
resource "aws_iam_policy" "grafana_cloudwatch" {
  name        = "${var.cluster_name}-grafana-cloudwatch"
  description = "IAM policy for Grafana CloudWatch access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:DescribeAlarmsForMetric",
          "cloudwatch:DescribeAlarmHistory",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:GetMetricData",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents",
          "logs:FilterLogEvents",
          "logs:StartQuery",
          "logs:StopQuery",
          "logs:GetQueryResults",
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "tag:GetResources"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "grafana_cloudwatch" {
  policy_arn = aws_iam_policy.grafana_cloudwatch.arn
  role       = module.grafana_irsa_role.iam_role_name
}