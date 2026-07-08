# End-to-End Application Delivery on Azure Virtual Machines with SQL Server Always On Availability Groups

This project builds an end-to-end application delivery platform on Azure using Terraform, Ansible, Azure DevOps, Jenkins, Azure Virtual Machines, SQL Server Always On Availability Groups, Azure Load Balancer, Azure Key Vault, Azure Monitor, Prometheus, Grafana, SonarQube, Trivy, and OWASP security best practices.

## Architecture

- Azure Virtual Network
- Public and private subnets
- Azure Load Balancer for application traffic
- Azure VM Scale Set for the application tier
- SQL Server Always On Availability Groups
- DNN Listener
- Cloud Witness using Azure Storage Account
- Azure Key Vault for secrets
- Azure Monitor, Prometheus, and Grafana for monitoring
- Azure DevOps and Jenkins for CI/CD

## Branching Strategy

- `main`: Stable, tested code
- `dev`: Development and testing branch
