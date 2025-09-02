# EKS Monitoring Stack

A comprehensive monitoring and observability stack for Amazon EKS using Prometheus, Grafana, and Fluent Bit with automated CI/CD deployment.

## Overview

This project implements a production-ready monitoring solution that includes:

- **Prometheus** for metrics collection and alerting
- **Grafana** for visualization and dashboards
- **Fluent Bit** for log aggregation and forwarding
- **Terraform** for infrastructure as code
- **Helm** for Kubernetes application deployment
- **GitHub Actions** for CI/CD automation

## Architecture

The solution follows cloud-native best practices with:

- Multi-environment support (dev, staging, prod)
- IAM Roles for Service Accounts (IRSA) for secure AWS integration
- Persistent storage for metrics and dashboards
- High availability configurations for production
- Comprehensive security policies and network isolation

## Prerequisites

- AWS CLI configured with appropriate permissions
- kubectl installed and configured
- Terraform >= 1.6.0
- Helm >= 3.13.0
- Docker (for local testing)

## Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url>
cd eks-monitoring-stack
```

### 2. Configure AWS Credentials

```bash
aws configure
# or use AWS SSO, IAM roles, etc.
```

### 3. Initialize Terraform Backend

First, create the S3 bucket and DynamoDB table for state management:

```bash
cd terraform
terraform init
terraform apply -target=aws_s3_bucket.terraform_state -target=aws_dynamodb_table.terraform_locks
```

### 4. Deploy Infrastructure

```bash
# Initialize with backend configuration
terraform init -backend-config="backend-config/dev.conf"

# Plan and apply
terraform plan -var-file="environments/dev.tfvars"
terraform apply -var-file="environments/dev.tfvars"
```

### 5. Deploy Monitoring Stack

```bash
# Update kubeconfig
aws eks update-kubeconfig --region us-east-1 --name eks-monitoring-dev

# Create namespaces
kubectl create namespace monitoring
kubectl create namespace logging

# Deploy Helm chart
cd ../helm/monitoring-stack
helm dependency update
helm install monitoring-stack . -n monitoring -f values-dev.yaml
```

## Project Structure

```
├── terraform/                 # Infrastructure as Code
│   ├── main.tf               # Main Terraform configuration
│   ├── variables.tf          # Variable definitions
│   ├── outputs.tf            # Output values
│   ├── vpc.tf                # VPC configuration
│   ├── eks.tf                # EKS cluster configuration
│   ├── iam.tf                # IAM roles and policies
│   ├── security-groups.tf    # Security group definitions
│   ├── addons.tf             # EKS add-ons
│   ├── backend.tf            # Terraform backend setup
│   ├── environments/         # Environment-specific variables
│   └── backend-config/       # Backend configuration files
├── helm/                     # Helm charts
│   └── monitoring-stack/     # Main monitoring stack chart
│       ├── Chart.yaml        # Chart metadata
│       ├── values.yaml       # Default values
│       ├── values-dev.yaml   # Development overrides
│       ├── values-staging.yaml # Staging overrides
│       └── values-prod.yaml  # Production overrides
├── .github/workflows/        # GitHub Actions workflows
│   ├── build-and-test.yml    # Build and validation pipeline
│   ├── deploy.yml            # Deployment pipeline
│   └── validate.yml          # Post-deployment validation
└── README.md                 # This file
```

## Environment Configuration

### Development
- Smaller resource allocations
- Shorter retention periods
- Single replicas for most components
- Basic security configurations

### Staging
- Production-like resource allocations
- Standard retention periods
- Limited high availability
- Enhanced security configurations

### Production
- Full resource allocations
- Extended retention periods
- High availability configurations
- Complete security hardening

## CI/CD Pipeline

The project includes three GitHub Actions workflows:

1. **Build and Test** (`build-and-test.yml`)
   - Terraform validation and formatting
   - Helm chart linting and templating
   - Security scanning with Trivy
   - YAML validation

2. **Deploy** (`deploy.yml`)
   - Infrastructure deployment with Terraform
   - Monitoring stack deployment with Helm
   - Multi-environment support
   - Automated rollback on failure

3. **Validate** (`validate.yml`)
   - Health checks for all components
   - Metrics collection validation
   - Dashboard accessibility tests
   - Log forwarding verification

## Security Features

- IAM Roles for Service Accounts (IRSA)
- Network policies for pod-to-pod communication
- Pod Security Standards enforcement
- Secrets management with AWS Secrets Manager
- Container image vulnerability scanning
- Encrypted storage and transit

## Monitoring Components

### Prometheus
- Metrics collection from Kubernetes and applications
- Custom recording and alerting rules
- Persistent storage with configurable retention
- High availability setup in production

### Grafana
- Pre-configured dashboards for Kubernetes monitoring
- AWS CloudWatch integration
- IAM-based authentication
- Dashboard provisioning via ConfigMaps

### Fluent Bit
- Log collection from all pods and nodes
- Kubernetes metadata enrichment
- Multiple output destinations (CloudWatch, S3)
- Efficient resource utilization

## Customization

### Adding Custom Metrics
1. Create ServiceMonitor CRDs for your applications
2. Update Prometheus scrape configurations
3. Add custom recording rules if needed

### Custom Dashboards
1. Add dashboard JSON files to Helm chart
2. Update dashboard provisioning configuration
3. Deploy updated Helm chart

### Log Routing
1. Modify Fluent Bit configuration in values files
2. Add custom parsers for application logs
3. Configure additional output destinations

## Troubleshooting

### Common Issues

1. **Pods stuck in Pending state**
   - Check node capacity and resource requests
   - Verify storage class availability
   - Check for scheduling constraints

2. **Metrics not appearing**
   - Verify ServiceMonitor configurations
   - Check Prometheus targets page
   - Validate network policies

3. **Grafana dashboards not loading**
   - Check data source connectivity
   - Verify Prometheus service endpoints
   - Review Grafana logs for errors

### Useful Commands

```bash
# Check pod status
kubectl get pods -n monitoring -o wide

# View pod logs
kubectl logs -n monitoring <pod-name>

# Port forward to services
kubectl port-forward -n monitoring svc/monitoring-stack-kube-prom-prometheus 9090:9090
kubectl port-forward -n monitoring svc/monitoring-stack-grafana 3000:80

# Check Helm releases
helm list -n monitoring

# Validate Terraform configuration
terraform validate
terraform plan
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions and support:
- Create an issue in the GitHub repository
- Contact the DevOps team
- Check the troubleshooting section above