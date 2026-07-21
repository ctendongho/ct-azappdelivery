# End-to-End Application Delivery on Microsoft Azure using SQL Server Always On Availability Groups across multiple Azure Availability Zones with Azure DevOps.

![Azure](https://img.shields.io/badge/Microsoft%20Azure-Cloud-blue?logo=microsoftazure)
![Terraform](https://img.shields.io/badge/Terraform-IaC-623CE4?logo=terraform)
![Ansible](https://img.shields.io/badge/Ansible-Automation-EE0000?logo=ansible)
![Jenkins](https://img.shields.io/badge/Jenkins-CI%2FCD-D24939?logo=jenkins)
![SQL Server](https://img.shields.io/badge/SQL%20Server-Always%20On-red?logo=microsoftsqlserver)
![Grafana](https://img.shields.io/badge/Grafana-Monitoring-orange?logo=grafana)
![Prometheus](https://img.shields.io/badge/Prometheus-Metrics-E6522C?logo=prometheus)
![SonarQube](https://img.shields.io/badge/SonarQube-Code%20Quality-4E9BCD?logo=sonarqube)
![Trivy](https://img.shields.io/badge/Trivy-Security-1904DA)
![OWASP ZAP](https://img.shields.io/badge/OWASP-ZAP-green)

---

# Project Overview

This project demonstrates an end-to-end, highly available application delivery platform deployed across multiple Azure Availability Zones for fault tolerance and improved resilience. 

It combines Infrastructure as Code, Configuration Management, Continuous Integration, Continuous Delivery, Monitoring, Security, and High Availability into a single enterprise deployment platform that closely resembles real-world production environments.

The platform hosts a .NET Inventory Tracker application running on a Windows Virtual Machine Scale Set behind Azure Application Gateway. SQL Server Always On Availability Groups provide database high availability, while Terraform and Ansible automate infrastructure provisioning and server configuration. A Jenkins Multi-Branch CI/CD pipeline continuously validates infrastructure, builds the application, performs code quality and security scans with SonarQube, Trivy and OWASP ZAP, it deploys the application, and verifies the health of the platform before completing each deployment. The application is securely exposed over HTTPS through Azure Application Gateway with WAF v2.

---

# Business Problem

Many organizations still rely on manual deployment processes to provision infrastructure, configure servers, and release applications. Manual deployments often introduce configuration drift, increase the risk of human error, prolong recovery during outages, and make environments difficult to reproduce consistently.

Traditional deployment approaches also tend to separate infrastructure, application delivery, monitoring, and security into disconnected processes. As a result, deployments require significant manual effort, troubleshooting becomes time-consuming, and identifying production issues often takes longer than necessary.

This project addresses these challenges by implementing an intergrated, automated deployment approach. 

# Project Objectives

- Deploy a .NET Inventory Tracker application on Microsoft Azure accross multiple Availability Zones for fault tollerance.
- Provision the infrastructure using Terraform in order to eliminates manual deployments.
- Standardizes server configuration using Ansible.
- Automates application delivery using Jenkins Multi-Branch Pipelines for CI/CD.
- Implement SQL Server Always On Availability Groups for database high availability.
- Secure secrets using Azure Key Vault.
- Perform automated static code analysis with SonarQube.
- Scan the application for vulnerabilities using Trivy.
- Perform web application security testing using OWASP ZAP.
- Monitor the environment using Prometheus and Grafana.
- Validate platform health automatically after every deployment.

The result is a repeatable, secure, highly available, and production-ready deployment platform that significantly reduces operational effort and cost while improving deployment consistency and reliability.

---

# Live Demo
Application URL (application currently down after destroying environment for cost savings)

https://ctinventorytracker.com

---

# Enterprise Architecture

The following diagram illustrates the complete Azure platform and how each service communicates with the others.

> **Architecture Diagram**

<p align="center">
<img src="docs/architecture/Architectural-Diagram.png" width="100%">
</p>

The architecture is designed around security, scalability, automation, and high availability and fault tollerance.

User traffic enters through Azure Application Gateway, which provides HTTPS termination and routes requests to the Windows Virtual Machine Scale Set hosting the Inventory Tracker application. The application communicates with SQL Server Always On Availability Groups deployed across two availability zones for database resilience.

A dedicated management virtual machine hosts Jenkins, Terraform, Ansible, SonarQube, Prometheus, Grafana, Docker, and Azure CLI, providing a centralized administration and CI/CD environment.

Azure Key Vault securely stores sensitive configuration while Managed Identity allows Azure resources to authenticate without embedding credentials within the application or deployment scripts.

Monitoring and security are integrated throughout the deployment lifecycle using Prometheus, Grafana, SonarQube, Trivy, and OWASP ZAP.

---

# Technologies Used

| Technology | Purpose in this Project |
|------------|-------------------------|
| Microsoft Azure | Cloud platform hosting the entire environment |
| Terraform | Infrastructure as Code (IaC) |
| Ansible | Windows Server and application configuration |
| Jenkins | Multi-Branch Continuous Integration / Continuous Delivery |
| Git & GitHub | Source control and version management |
| Azure Application Gateway | HTTPS entry point and Layer 7 load balancing |
| Azure Virtual Machine Scale Set | Highly available application servers |
| Windows Server 2022 | Application hosting platform |
| IIS | Web server hosting the Inventory Tracker application |
| SQL Server 2022 Enterprise | Relational database engine |
| SQL Server Always On Availability Groups | Database high availability |
| Azure Key Vault | Secret and certificate management |
| Azure Managed Identity | Passwordless authentication |
| Active Directory Domain Services | Authentication and domain management |
| SonarQube | Static code quality analysis |
| Trivy | Vulnerability and secret scanning |
| OWASP ZAP | Dynamic web application security testing |
| Prometheus | Metrics collection |
| Grafana | Monitoring dashboards |
| Docker | Container runtime used for security tooling |
| PowerShell | Windows automation |
| Azure CLI | Azure administration |

---

# Key Features

- Azure Multi-AZ deployment.
- Fully automated Infrastructure as Code deployment using Terraform.
- Automated Windows Server configuration using Ansible.
- Enterprise Jenkins Multi-Branch CI/CD pipeline.
- Development and Production deployment workflows.
- SQL Server Always On Availability Groups with DNN Listener.
- Highly available Windows Virtual Machine Scale Set.
- Azure Application Gateway with HTTPS.
- Azure Key Vault integration.
- Static code quality analysis using SonarQube.
- Vulnerability scanning using Trivy.
- Web application security testing using OWASP ZAP.
- Prometheus metrics collection.
- Grafana monitoring dashboards.
- Automated platform health validation after deployment.
- Infrastructure validation before every deployment.
- Automated IIS deployment.
- Automated application packaging.
- Secure secret management.
- End-to-end deployment automation.

---

## Repository Structure

```text
ct-azappdelivery/
├── application/
│   └── CTInventoryPortal/       
├── ansible/
│   ├── inventory/                
│   ├── playbooks/                
│   ├── group_vars/               
│   └── roles/                    
├── terraform/                    
├── jenkins/                     
├── scripts/                     
├── docs/
│   ├── architecture/             
│   └── screenshots/              
├── Jenkinsfile                   
├── ansible.cfg                   
├── .gitignore
└── README.md
```

---

## CI/CD Pipeline

```text
Developer
     │
     ▼
GitHub
(dev / main branches)
     │
     ▼
Jenkins Multi-Branch Pipeline
     │
     ▼
Checkout and Branch Validation
     │
     ▼
Terraform Init / Validate / Plan
(dev only)
     │
     ▼
Ansible Inventory and Playbook Validation
(dev only)
     │
     ▼
.NET Application Build
     │
     ▼
SonarQube Scan and Quality Gate
(dev only)
     │
     ▼
Trivy Security Scan
(dev only)
     │
     ▼
Application Packaging
     │
     ▼
Manual Deployment Approval
(dev only)
     │
     ▼
Ansible Deployment
     │
     ▼
Azure VM Scale Set and IIS
     │
     ▼
OWASP ZAP Security Scan
(post-deployment)
     │
     ▼
Platform Health Checks
     │
     ▼
Deployment Summary
```

The `dev` branch runs the complete validation and security workflow and requires manual approval before deployment. The `main` branch automatically builds, packages, deploys, and validates changes that have already been tested in development.

---

## Deployment Guide

### Clone the Repository

```bash
git clone https://github.com/ctendongho/ct-azappdelivery.git

cd ct-azappdelivery

git checkout dev
```

### Authenticate to Azure

```bash
az login --use-device-code

az account show
```

### Configure Terraform Variables

```bash
cd terraform

cp terraform.tfvars.example terraform.tfvars

vi terraform.tfvars
```

> `terraform.tfvars` contains sensitive values and is excluded from GitHub.

### Deploy the Infrastructure

```bash
terraform init

terraform validate

terraform plan

terraform apply
```

### Validate Ansible Connectivity

```bash
cd ..

ansible windows \
  -m ansible.windows.win_ping \
  --ask-vault-pass
```

### Build the Application

```bash
dotnet build \
  application/CTInventoryPortal/CTInventoryPortal.csproj \
  --configuration Release
```

### Run the Trivy Security Scan

```bash
trivy fs \
  --scanners vuln,secret,misconfig \
  --severity HIGH,CRITICAL \
  application/
```

### Deploy the Application

```bash
ansible-playbook \
  -i ansible/inventory/hosts.ini \
  ansible/playbooks/deploy-application.yml \
  --ask-vault-pass
```

### Run the OWASP ZAP Scan

```bash
mkdir -p reports

docker run --rm \
  -v "$(pwd)/reports:/zap/wrk:rw" \
  ghcr.io/zaproxy/zaproxy:stable \
  zap-baseline.py \
  -t https://ctinventorytracker.com/ \
  -m 5 \
  -r owasp-zap-report.html
```

### Deploy Through Jenkins

Push changes to `dev` to trigger the complete validation and deployment workflow:

```bash
git add .

git commit -m "Update application delivery platform"

git push origin dev
```

After the `dev` pipeline succeeds, merge the tested changes into `main`.

---

## Validation

### Verify the Application

```bash
curl -I https://ctinventorytracker.com
```

### Verify the Health Endpoint

```bash
curl https://ctinventorytracker.com/health
```

Expected response:

```text
Healthy
```

### Verify the Application Servers

```bash
ansible app_servers \
  -m ansible.windows.win_ping \
  --ask-vault-pass
```

### Verify SQL Server Services

```bash
ansible sql_servers \
  -m ansible.windows.win_shell \
  -a 'Get-Service MSSQLSERVER' \
  --ask-vault-pass
```

### Verify the Availability Group

In SQL Server Management Studio, confirm:

- `CTInventoryAG` is healthy.
- `ct-azappsql01` and `ct-azappsql02` are connected.
- The primary and secondary replicas are synchronized.
- The Inventory Tracker data is available.

```sql
USE CTInvTracker;
GO

SELECT *
FROM dbo.InventoryItems;
GO
```

### Verify Application Gateway

```bash
az network application-gateway show-backend-health \
  --resource-group ct-azapps-rg \
  --name ct-appgateway
```

### Verify Monitoring

```bash
curl http://localhost:9090/-/healthy

curl http://localhost:3000/api/health
```

A successful Jenkins deployment completes with:

```text
OVERALL PLATFORM STATUS: HEALTHY
```
---

## Platform Screenshots

# Inventory Tracker application web portal

The application demonstrates a typical enterprise inventory management system where users can create, update, edit, and manage inventory records stored within a SQL Server database.

<p align="center">
<img src="docs/screenshots/Inventory-Tracker-application-web-portal.png" width="100%">
</p>

---

# SQL Server Always On Availability Groups

SQL Server Always On Availability Groups provide high availability for the Inventory Tracker database.

The primary replica processes all read and write operations while continuously synchronizing changes to the secondary replica. If the primary server becomes unavailable, the Availability Group fails over to the secondary replica, allowing the application to continue operating with zero downtime.

The screenshot below shows the Availability Group operating normally with the InventoryItems table queried from the active primary replica.

<p align="center">
<img src="docs/screenshots/SQL-Server-Dashboard.png" width="100%">
</p>

---

# SonarQube Static Code Analysis

Before deployment, Jenkins performs static code analysis using SonarQube to scan for bugs, security vulnerabilities, security hotspots, and code smells. This ensures that only code meeting the defined quality standards progresses through the deployment pipeline.

The project successfully passes the configured Quality Gate with:

- No New Bugs
- No New Vulnerabilities
- No New Code Smells
- Passing Quality Gate

<p align="center">
<img src="docs/screenshots/SonarQube-Dashboard.png" width="100%">
</p>

---

# Trivy Security Scan

Trivy is integrated directly into the Jenkins pipeline to perform automated vulnerability and secret scanning to find known vulnerabilities, misconfigurations, and exposed secrets in code and infrastructure before deployment.

<p align="center">
<img src="docs/screenshots/Trivy-Security-Scan.png" width="100%">
</p>

---

# OWASP ZAP Security Scan

After deployment, OWASP ZAP performs an automated baseline scan against the running Inventory Tracker application.

Unlike static analysis tools, OWASP ZAP evaluates the live application from an attacker's perspective by inspecting HTTP responses, application headers, session handling, and common web application security risks.

This additional layer of testing helps verify that the deployed application follows recommended web application security best practices.

The completed scan reported:

- No Critical Findings
- No High Severity Vulnerabilities
- Informational security recommendations only

<p align="center">
<img src="docs/screenshots/OWASP-ZAP-scan.png" width="100%">
</p>

---

# Grafana Monitoring Dashboard

Prometheus continuously collects infrastructure and application metrics from the platform, while Grafana visualizes those metrics through interactive dashboards.

The monitoring solution provides visibility into platform performance, helping administrators quickly identify resource utilization trends, application behavior, infrastructure health and anomalies before they become an issue.

Typical metrics include:

- CPU Utilization
- Memory Utilization
- Disk Usage
- Network Activity
- IIS Availability
- Application Health

<p align="center">
<img src="docs/screenshots/Grafana-dashboard.png" width="100%">
</p>

---

# Azure Application Gateway

Application Gateway securely exposes the application through HTTPS. By routing incoming requests to the Virtual Machine Scale Set, Application Gateway also improves both availability and scalability while simplifying external access to the application.

Its responsibilities include:

- HTTPS termination
- Layer 7 load balancing
- Intelligent request routing
- SSL certificate management
- Secure client connections



<p align="center">
<img src="docs/screenshots/Application-gateway.png" width="100%">
</p>

---

# Azure Key Vault

Azure Key Vault provides centralized and secure storage for sensitive configuration such as credentials, secrets, and certificates.

Rather than embedding sensitive values within Terraform, Ansible, or the application itself, secrets are securely managed through Key Vault and accessed using Azure Managed Identity whenever possible.

<p align="center">
<img src="docs/screenshots/Azure-key-vaults.png" width="100%">
</p>

---

# Challenges Encountered

- Jenkins initially had trouble connecting to Azure because the wrong service principal secret value was added. After correcting the credentials and RBAC permissions, the pipeline was able to authenticate successfully.
- Ansible briefly lost WinRM connectivity to one VM Scale Set instance. Checking the server status, private IP, firewall rules, and WinRM port helped restore communication.
- SonarQube authentication failed because the token was not being passed correctly. Updating the Jenkins credential configuration allowed the scan and Quality Gate to complete.
- Application Gateway and Jenkins needed a reliable way to confirm the application was healthy. A dedicated /health endpoint was added and used for backend probes and post-deployment checks.
- OWASP ZAP also identified a few security-header warnings. Most were corrected through Ansible, while the remaining low-risk findings were documented for future improvements.
  
---

# Lessons Learned

Developing this platform provided valuable practical experience across multiple areas of cloud engineering and DevOps.

Some of the most significant lessons learned include:

- Infrastructure as Code dramatically improves deployment consistency and repeatability.
- Configuration management is equally important as infrastructure provisioning.
- CI/CD pipelines should include validation, security scanning, and health verification—not just application deployment.
- Monitoring should be designed into a platform from the beginning rather than added later.
- High availability involves much more than deploying multiple servers; networking, clustering, storage, and application design all play important roles.
- Security is most effective when integrated throughout the software delivery lifecycle instead of being treated as a separate activity.

Perhaps the most important lesson was understanding how multiple technologies work together to deliver a single business solution rather than viewing each technology independently.

---

# Future Improvements

Although the platform already demonstrates enterprise application delivery, several enhancements could be implemented in future iterations.

Potential improvements include:

- Azure Front Door for global traffic distribution.
- Azure Web Application Firewall (WAF) policies.
- Azure Backup and Azure Site Recovery.
- Kubernetes-based application hosting using Azure Kubernetes Service (AKS).
- GitHub Actions deployment workflow.
- Infrastructure compliance scanning with Microsoft Defender for Cloud.
  
---

# Author

**Charles Tendongho**

SQL Server DBA | Cloud Engineer | DevOps Engineer

GitHub: https://github.com/ctendongho

LinkedIn: https://www.linkedin.com/in/charles-tendongho-3500901a9/

---

# License

This project is licensed under the MIT License.
