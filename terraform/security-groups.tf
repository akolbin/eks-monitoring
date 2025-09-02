# Additional Security Groups for EKS Monitoring Stack

# Security group for monitoring components
resource "aws_security_group" "monitoring" {
  name_prefix = "${var.cluster_name}-monitoring-"
  vpc_id      = module.vpc.vpc_id

  description = "Security group for monitoring stack components"

  # Prometheus metrics scraping
  ingress {
    description = "Prometheus metrics"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Grafana web interface
  ingress {
    description = "Grafana web interface"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # AlertManager
  ingress {
    description = "AlertManager"
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Node exporter
  ingress {
    description = "Node exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Fluent Bit metrics
  ingress {
    description = "Fluent Bit metrics"
    from_port   = 2020
    to_port     = 2020
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-monitoring-sg"
  })
}

# Security group for ALB/NLB
resource "aws_security_group" "alb" {
  name_prefix = "${var.cluster_name}-alb-"
  vpc_id      = module.vpc.vpc_id

  description = "Security group for Application Load Balancer"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-alb-sg"
  })
}