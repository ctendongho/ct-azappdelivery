# End-to-End Enterprise Application Delivery on Microsoft Azure using SQL Server Always On Availability Groups

![Microsoft Azure](https://img.shields.io/badge/Microsoft_Azure-0078D4?logo=microsoftazure&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-844FBA?logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-EE0000?logo=ansible&logoColor=white)
![Jenkins](https://img.shields.io/badge/Jenkins-D24939?logo=jenkins&logoColor=white)
![SQL Server](https://img.shields.io/badge/SQL_Server-CC2927?logo=microsoftsqlserver&logoColor=white)
![.NET 8](https://img.shields.io/badge/.NET_8-512BD4?logo=dotnet&logoColor=white)
![SonarQube](https://img.shields.io/badge/SonarQube-4E9BCD?logo=sonarqube&logoColor=white)
![Trivy](https://img.shields.io/badge/Trivy-1904DA?logo=aqua&logoColor=white)
![OWASP ZAP](https://img.shields.io/badge/OWASP_ZAP-00549E?logo=owasp&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?logo=grafana&logoColor=white)

An end-to-end enterprise application delivery platform built on Microsoft Azure using Infrastructure as Code, configuration management, automated CI/CD, application security scanning, centralized secrets management, monitoring, and SQL Server high availability.

The platform deploys an ASP.NET Core Inventory Tracker application across two Windows IIS application instances in an Azure Virtual Machine Scale Set. The database layer uses two SQL Server nodes configured in a SQL Server Always On Availability Group with a Distributed Network Name listener. Jenkins, Terraform, Ansible, SonarQube, Trivy, OWASP ZAP, Prometheus, Grafana, Azure Application Gateway, Azure Key Vault, Azure Monitor, and Application Insights are integrated to provide automated delivery, validation, security, observability, scalability, and resilience.

---

## Demo

[https://ctinventorytracker.com](https://ctinventorytracker.com)

---

## Solution Architecture

The solution is deployed primarily in the `ct-azapps-rg` resource group in the **Central US** Azure region.

The application workload is hosted inside `ct-azappvnet` using separate subnets for public services, the application tier, Active Directory, and SQL Server. Azure Application Gateway receives public HTTPS traffic and routes healthy requests to the two IIS application instances in `ct-azappvmss`.

The database tier consists of `ct-azappsql01` and `ct-azappsql02`, configured as replicas in the `CTInventoryAG` SQL Server Always On Availability Group. The application connects through the Distributed Network Name listener on TCP port `14330`.

The management and DevSecOps layer includes Jenkins, Terraform, Ansible, SonarQube, Trivy, OWASP ZAP, Prometheus, Grafana, Docker, Azure Monitor, Application Insights, Azure Key Vault, and managed identity integration.

![CT Azure Application Delivery Architecture](docs/architecture/Architectural-Diagram.png)

---

## Technologies Used

| Category | Technology |
|---|---|
| Cloud Platform | Microsoft Azure |
| Azure Region | Central US |
| Resource Group | `ct-azapps-rg` |
| Infrastructure as Code | Terraform |
| Configuration Management | Ansible |
| CI/CD | Jenkins Multibranch Pipeline |
| Source Control | Git and GitHub |
| Application Framework | ASP.NET Core 8 |
| Web Server | Microsoft IIS |
| Application Compute | Azure Windows Virtual Machine Scale Set |
| Application Scale Set | `ct-azappvmss` |
| Application Instances | `azapp000000` and `azapp000001` |
| Application Gateway | `ct-appgateway` |
| Virtual Network | `ct-azappvnet` |
| Network Security | Azure Network Security Groups |
| Identity Services | Active Directory Domain Services |
| Domain Controller | `ct-azappdc01` |
| Database Platform | Microsoft SQL Server |
| SQL Server Nodes | `ct-azappsql01` and `ct-azappsql02` |
| Database High Availability | SQL Server Always On Availability Groups |
| Availability Group | `CTInventoryAG` |
| SQL Connectivity | Distributed Network Name Listener |
| SQL Listener Port | `14330` |
| Secrets Management | Azure Key Vault |
| Identity Integration | Azure Managed Identity and RBAC |
| Application Monitoring | Azure Application Insights |
| Cloud Monitoring | Azure Monitor |
| Metrics Collection | Prometheus |
| Dashboards | Grafana |
| Static Code Analysis | SonarQube |
| Dependency and Secret Scanning | Trivy |
| Dynamic Web Security Testing | OWASP ZAP |
| Container Runtime | Docker |
| Automation Languages | Bash, PowerShell, HCL, YAML and Groovy |

---

## Key Features

- Provisioned the Azure infrastructure using reusable Terraform configuration.
- Implemented a segmented Azure network using dedicated public, application, Active Directory, and database subnets.
- Deployed the Inventory Tracker application to two Windows IIS instances in `ct-azappvmss`.
- Configured Azure Application Gateway for public HTTPS access, Layer 7 routing, health probes, and backend traffic distribution.
- Created a dedicated `/health` endpoint for application and gateway health validation.
- Configured Active Directory Domain Services using `ct-azappdc01`.
- Deployed SQL Server nodes `ct-azappsql01` and `ct-azappsql02` across separate database subnets.
- Configured the `CTInventoryAG` SQL Server Always On Availability Group.
- Implemented a Distributed Network Name listener on port `14330`.
- Automated Windows Server configuration and application deployment with Ansible.
- Built a Jenkins multibranch pipeline for the `dev` and `main` branches.
- Configured full validation and a manual deployment approval gate on `dev`.
- Configured automatic deployment and production health validation on `main`.
- Integrated SonarQube static code analysis and Quality Gate enforcement.
- Integrated Trivy vulnerability, secret, and supported misconfiguration scanning.
- Performed OWASP ZAP baseline security testing against the public HTTPS endpoint.
- Stored certificates, credentials, connection strings, and secrets in Azure Key Vault.
- Used Azure managed identity and RBAC to reduce direct credential use.
- Collected infrastructure and application metrics with Prometheus.
- Created Grafana dashboards for platform and service visibility.
- Integrated Application Insights and Azure Monitor for application and Azure resource monitoring.
- Added automated post-deployment checks for the website, health endpoint, IIS instances, SQL Server services, Availability Group, DNN listener, Prometheus, Grafana, SonarQube, and Docker.
- Produced clean health-summary tables in Jenkins after deployment.

---

## Repository Structure

```text
.
├── ansible/
│   ├── inventory/
│   ├── playbooks/
│   ├── roles/
│   └── group_vars/
│
├── application/
│   └── CTInventoryPortal/
│
├── docs/
│   ├── architecture/
│   └── screenshots/
│
├── jenkins/
│   ├── ansible-validate.sh
│   ├── build-application.sh
│   ├── deploy-application.sh
│   ├── package-application.sh
│   ├── platform-health.sh
│   ├── sonarqube-scan.sh
│   ├── terraform-validate.sh
│   └── trivy-scan.sh
│
├── reports/
├── scripts/
├── security-reports/
│
├── terraform/
│   ├── application-gateway.tf
│   ├── autoscaling.tf
│   ├── key-vault.tf
│   ├── management-vm.tf
│   ├── monitoring.tf
│   ├── network-security.tf
│   ├── network.tf
│   ├── provider.tf
│   ├── resource-group.tf
│   ├── sql.tf
│   ├── storage.tf
│   ├── terraform.tfvars.example
│   ├── variables.tf
│   ├── vmss-extension.tf
│   ├── vmss.tf
│   └── vpn-gateway.tf
│
├── Jenkinsfile
├── ansible.cfg
└── README.md
```

---

## CI/CD Pipeline

The project uses a Jenkins Multibranch Pipeline that discovers and builds the `dev` and `main` branches independently.

### Development Branch Workflow

The `dev` branch performs the complete validation, build, security, approval, deployment, and platform-health workflow.

```text
Developer Push
      |
      v
GitHub dev Branch
      |
      v
Jenkins Multibranch Pipeline
      |
      v
Terraform Format Check
      |
      v
Terraform Initialization
      |
      v
Terraform Validation and Read-Only Plan
      |
      v
Ansible Inventory Validation
      |
      v
Ansible Syntax Validation
      |
      v
Windows Connectivity Validation
      |
      v
ASP.NET Core Release Build
      |
      v
SonarQube Static Code Analysis
      |
      v
SonarQube Quality Gate
      |
      v
Trivy Security Scan
      |
      v
Application Packaging
      |
      v
Manual Deployment Approval
      |
      v
Ansible Deployment to Both VMSS Instances
      |
      v
IIS Security Header Configuration
      |
      v
End-to-End Platform Health Validation
```

### Main Branch Workflow

The `main` branch represents production promotion. Tested changes are merged from `dev`, then built, packaged, deployed, and validated automatically.

```text
Merge dev into main
      |
      v
GitHub main Branch
      |
      v
Jenkins Multibranch Pipeline
      |
      v
ASP.NET Core Release Build
      |
      v
Application Packaging
      |
      v
Automatic Ansible Deployment
      |
      v
IIS Security Header Configuration
      |
      v
Production Platform Health Validation
      |
      v
Deployment Summary
```

### Branch Behavior

| Pipeline Stage | `dev` | `main` |
|---|---:|---:|
| Checkout | Yes | Yes |
| Branch Validation | Yes | Yes |
| Terraform Format, Validate and Plan | Yes | No |
| Ansible Validation | Yes | No |
| ASP.NET Core Build | Yes | Yes |
| SonarQube Analysis | Yes | No |
| SonarQube Quality Gate | Yes | No |
| Trivy Security Scan | Yes | No |
| Application Packaging | Yes | Yes |
| Manual Deployment Approval | Yes | No |
| Application Deployment | After approval | Automatic |
| Platform Health Validation | Full development validation | Production validation |
| Build Artifact Archiving | Yes | Yes |

### Automated Platform Validation

| Component | Validation |
|---|---|
| Terraform | Formatting, initialization, validation, and plan completion |
| Ansible | Inventory, syntax, variables, and connectivity |
| .NET Application | Release build completed |
| SonarQube | Analysis completed and Quality Gate passed |
| Trivy | Security report generated |
| Inventory Website | Public HTTPS returned HTTP 200 |
| Application Health | `/health` returned HTTP 200 |
| VMSS Application Servers | Both IIS application instances responded |
| SQL Server Services | `MSSQLSERVER` running on both SQL nodes |
| SQL Cluster and AG | Cluster and Availability Group health validated |
| DNN Listener | Listener port `14330` reachable |
| Prometheus | Health endpoint returned HTTP 200 |
| Grafana | API health confirmed database status OK |
| SonarQube Server | System status returned UP |
| Docker Engine | Docker daemon reachable |

---

## Deployment Guide

### Prerequisites

- An Azure subscription
- Azure CLI
- Terraform
- Ansible
- Git
- .NET 8 SDK
- Docker
- PowerShell
- Jenkins
- Access to the required Azure resource scopes
- Windows and SQL Server administrative credentials
- Ansible Vault password

### 1. Clone the Repository

```bash
git clone https://github.com/ctendongho/ct-azappdelivery.git
cd ct-azappdelivery
```

### 2. Create the Private Terraform Variables File

The real `terraform.tfvars` file is excluded from Git because it contains sensitive values.

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit the private file and replace demonstration values with the correct environment-specific configuration:

```bash
vi terraform.tfvars
```

Never commit `terraform.tfvars` to source control.

### 3. Authenticate to Azure

```bash
az login
az account show
```

Jenkins uses an Azure service principal stored in Jenkins credentials.

### 4. Initialize Terraform

```bash
terraform init
```

### 5. Validate Terraform

```bash
terraform fmt -check -recursive
terraform validate
```

### 6. Review the Plan

```bash
terraform plan
```

Review every planned addition, update, replacement, and deletion before proceeding.

### 7. Provision the Infrastructure

```bash
terraform apply
```

### 8. Validate Ansible Connectivity

Return to the repository root:

```bash
cd ..
```

Test all Windows hosts:

```bash
ansible windows \
  -m ansible.windows.win_ping \
  --ask-vault-pass
```

Test only application servers:

```bash
ansible app_servers \
  -m ansible.windows.win_ping \
  --ask-vault-pass
```

Test only SQL Server nodes:

```bash
ansible sql_servers \
  -m ansible.windows.win_ping \
  --ask-vault-pass
```

### 9. Validate Ansible Playbooks

```bash
ansible-playbook \
  --syntax-check \
  ansible/playbooks/deploy-application.yml
```

### 10. Build the Application

```bash
dotnet build \
  application/CTInventoryPortal/CTInventoryPortal.csproj \
  --configuration Release
```

### 11. Deploy with Ansible

```bash
ansible-playbook \
  -i ansible/inventory/hosts.ini \
  ansible/playbooks/deploy-application.yml \
  --ask-vault-pass
```

### 12. Run the Development Pipeline

```bash
git checkout dev
git add .
git commit -m "Update application delivery platform"
git push origin dev
```

Jenkins runs the development workflow and pauses before deployment for manual approval.

### 13. Promote to Main

After `dev` completes successfully:

```bash
git checkout main
git pull origin main
git merge --no-ff dev -m "Promote tested development changes to main"
git push origin main
```

Jenkins automatically runs the production workflow.

---

## Validation

### Validate the Public Website

```bash
curl -I https://ctinventorytracker.com
```

Expected result:

```text
HTTP/2 200
```

### Validate the Application Health Endpoint

```bash
curl https://ctinventorytracker.com/health
```

Expected result:

```text
Healthy
```

### Validate Both VMSS Application Servers

```bash
ansible app_servers \
  -m ansible.windows.win_ping \
  --ask-vault-pass
```

Expected result from both application instances:

```text
ping: pong
```

### Validate IIS Application Health

```bash
ansible app_servers \
  -m ansible.windows.win_uri \
  -a "url=http://localhost/health method=GET status_code=200" \
  --ask-vault-pass
```

### Validate SQL Server Services

```bash
ansible sql_servers \
  -m ansible.windows.win_shell \
  -a 'Get-Service MSSQLSERVER' \
  --ask-vault-pass
```

### Validate the Distributed Network Name Listener

```powershell
Test-NetConnection `
  CTInventoryListener.ad.ctinventorytracker.com `
  -Port 14330
```

### Validate Prometheus

```bash
curl http://localhost:9090/-/healthy
```

### Validate Grafana

```bash
curl http://localhost:3000/api/health
```

### Validate SonarQube

```bash
curl http://localhost:9000/api/system/status
```

### Validate Docker

```bash
docker info
```

### Validate Terraform

```bash
cd terraform
terraform validate
```

### Validate Ansible Syntax

```bash
ansible-playbook \
  --syntax-check \
  ansible/playbooks/deploy-application.yml
```

### Run a Trivy Scan

```bash
cd ~/ct-azappdelivery

trivy fs \
  --scanners vuln,secret,misconfig \
  --severity LOW,MEDIUM,HIGH,CRITICAL \
  application/
```

### Run an OWASP ZAP Baseline Scan

```bash
cd ~/ct-azappdelivery
mkdir -p reports

docker run --rm \
  -v "$(pwd)/reports:/zap/wrk:rw" \
  ghcr.io/zaproxy/zaproxy:stable \
  zap-baseline.py \
  -t https://ctinventorytracker.com/ \
  -m 5 \
  -r owasp-zap-report.html \
  -J owasp-zap-report.json \
  -x owasp-zap-report.xml
```

---

## Platform Screenshots

### Jenkins Multibranch Pipeline

The Jenkins multibranch project discovers the `dev` and `main` branches and maintains an independent build history for each workflow. The development branch performs complete validation and requires deployment approval, while the main branch performs automatic production deployment.

![Jenkins Multibranch Pipeline](docs/screenshots/Jenkins-Multi-Branch-Pipeline1.png)

---

### Jenkins Main Pipeline Scan Results

The main-branch pipeline builds and packages the application, deploys it to both IIS instances, and performs production health checks. The final summary confirms the health of the application, VMSS instances, SQL Server services, SQL Cluster, Availability Group, DNN listener, Prometheus, Grafana, SonarQube, and Docker.

![Jenkins Main Pipeline Scan Results](docs/screenshots/Jenkins-Multi-Branch-Pipeline2.png)

---

### Inventory Tracker Web Portal

The Inventory Tracker is an ASP.NET Core application hosted on two Windows IIS instances in `ct-azappvmss`. Azure Application Gateway provides secure public access and routes traffic only to healthy backends.

![Inventory Tracker Web Portal](docs/screenshots/Inventory-Tracker-application-web-portal.png)

---

### SQL Server Always On Dashboard

The SQL Server dashboard shows the `CTInventoryAG` Availability Group, including the current primary and secondary replicas. The query output displays the records stored in the `dbo.InventoryItems` table, confirming application data availability through the high-availability database layer.

![SQL Server Always On Dashboard](docs/screenshots/SQL-Server-Dashboard.png)

---

### SonarQube Static Code Analysis

SonarQube analyzes the ASP.NET Core application during the development pipeline. The dashboard confirms a passing Quality Gate with no new bugs, vulnerabilities, or code smells.

![SonarQube Dashboard](docs/screenshots/SonarQube-Dashboard.png)

---

### Trivy Security Scan

Trivy scans supported application dependencies, files, secrets, and configuration content. The security scan provides vulnerability counts by severity and confirms whether Critical or High-risk findings require remediation.

![Trivy Security Scan](docs/screenshots/Trivy-Security-Scan.png)

---

### OWASP ZAP Security Scan

OWASP ZAP performs a baseline dynamic security assessment against the public application endpoint. The captured report summarizes passed checks, warnings, and the absence of Critical or High-risk findings.

![OWASP ZAP Security Scan](docs/screenshots/OWASP-ZAP-scan.png)

---

### Grafana and Prometheus Monitoring

Prometheus collects platform metrics, and Grafana displays them through operational dashboards. The dashboard provides visibility into service availability, infrastructure utilization, and application health.

![Grafana Dashboard](docs/screenshots/Grafana-dashboard.png)

---

### Azure Application Gateway

Azure Application Gateway provides public HTTPS access, Layer 7 routing, TLS integration, backend health probes, and traffic distribution across the two VMSS application instances.

![Azure Application Gateway](docs/screenshots/Application-gateway.png)

---

### Azure Key Vault

Azure Key Vault stores certificates, credentials, connection strings, and application secrets. Access is controlled through Azure RBAC and managed identity integration.

![Azure Key Vault](docs/screenshots/Azure-key-vaults.png)

---

## Challenges Encountered

### Protecting Terraform Secrets

**Challenge:** Terraform required administrator passwords, certificates, public IP restrictions, and other environment-specific values that could not be committed to GitHub.

**Resolution:** The real `terraform.tfvars` file was excluded using `.gitignore`. A safe `terraform.tfvars.example` file was committed to demonstrate the expected structure. Jenkins credentials and Ansible Vault were used for pipeline and deployment secrets.

### Azure Service Principal Authentication

**Challenge:** Jenkins initially could not authenticate Terraform successfully because of incorrect service-principal credential values.

**Resolution:** The Azure client ID, client secret value, tenant ID, and subscription ID were stored as separate Jenkins credentials and injected into the Terraform stage using the standard `ARM_*` environment variables.

### Azure RBAC Scope

**Challenge:** The Jenkins service principal could manage the main application resource group but could not read the peered management VNet and older network resources.

**Resolution:** The appropriate Reader and Contributor roles were granted at the minimum required resource-group scopes.

### Terraform State and Configuration Drift

**Challenge:** Some existing resources had historical names and resource-group references that differed from the current Terraform configuration.

**Resolution:** Terraform plans were reviewed carefully, state was preserved, and destructive changes were avoided until the configuration and state relationships were understood.

### Windows Automation with Ansible

**Challenge:** Windows automation required WinRM, domain credentials, Windows-specific modules, firewall rules, and Ansible Vault integration.

**Resolution:** Hosts were grouped into domain-controller, SQL Server, and application-server inventories. WinRM connectivity and authentication were validated before running configuration and deployment playbooks.

### VM Scale Set Connectivity

**Challenge:** One VMSS instance temporarily timed out during Ansible validation.

**Resolution:** Azure CLI was used to confirm both scale-set instances, private IP addresses, power states, and WinRM connectivity. Ansible `win_ping` was rerun successfully against both instances.

### SQL Server Always On Configuration

**Challenge:** Windows Server Failover Clustering, SQL Server Always On, synchronization, database membership, and DNN listener connectivity had to work together.

**Resolution:** The SQL Server nodes were validated through service checks, cluster validation playbooks, Availability Group checks, and DNN listener connectivity tests.

### SonarQube Token Injection

**Challenge:** The SonarQube scan initially failed because the token environment variable was overwritten or unavailable inside the scanner script.

**Resolution:** The Jenkins credential was injected using a dedicated `SONAR_TOKEN` variable, avoiding the variable-name collision.

### Jenkins Shell Compatibility

**Challenge:** The main production-health stage failed because Jenkins executed a multiline command using `/bin/sh`, which did not support `set -o pipefail`.

**Resolution:** The shell block was explicitly configured to run with Bash.

### Branch-Specific Pipeline Behavior

**Challenge:** Development required complete validation and manual approval, while main required automatic deployment without repeating all development scans.

**Resolution:** Jenkins `when` conditions were used to define separate `dev` and `main` workflows inside a single Jenkinsfile.

### Application Gateway Health Probes

**Challenge:** Azure Application Gateway needed a reliable health check before routing traffic to an IIS instance.

**Resolution:** A dedicated `/health` endpoint was implemented and validated locally and publicly.

### Web Security Hardening

**Challenge:** OWASP ZAP identified warnings related to JavaScript libraries, cache directives, CSP configuration, server headers, and cross-origin policy headers.

**Resolution:** Required IIS security headers were added through Ansible. Remaining warnings were documented as future hardening tasks.

---

## Lessons Learned

- High availability must be implemented across networking, compute, application, and database layers.
- SQL Server Always On protects the database layer, but the complete application also requires redundant web servers, healthy routing, monitoring, and automated recovery.
- Sensitive Terraform values must remain outside source control.
- Jenkins credentials and Ansible Vault provide safer automation than embedding passwords in code.
- Infrastructure validation should happen before application deployment.
- Development and production branches should have different controls and deployment behavior.
- A dedicated health endpoint simplifies Application Gateway routing, automated validation, and troubleshooting.
- Static analysis, dependency scanning, secret scanning, and dynamic web testing protect different parts of the delivery lifecycle.
- Post-deployment health checks should validate the complete platform rather than only the application build.
- Windows automation requires careful WinRM, firewall, DNS, domain, and credential configuration.
- Consistent Azure naming conventions make a large environment easier to understand and operate.
- Terraform state must be treated as a critical asset.
- RBAC permissions should be granted at the minimum scope required.
- A clean README and accurate architecture diagram are important parts of presenting a technical project professionally.

---

## Future Enhancements

- Replace direct jump-box access with Azure Bastion.
- Add Azure Firewall for centralized network inspection.
- Add Web Application Firewall protection to Azure Application Gateway.
- Add Azure Front Door for global entry, edge security, and regional expansion.
- Add private endpoints for Azure Key Vault, storage, and supported platform services.
- Store Terraform state remotely in an Azure Storage Account with locking and versioning.
- Rotate VM and SQL Server credentials through Azure Key Vault.
- Add Microsoft Defender for Cloud.
- Add Azure Policy for governance and configuration compliance.
- Add Azure Backup for SQL Server and critical virtual machines.
- Configure automated certificate rotation.
- Add centralized logging with Azure Log Analytics.
- Add Azure Monitor alert rules for Application Gateway, VMSS, SQL AG, and application failures.
- Generate the Ansible inventory dynamically from Azure.
- Add controlled automated SQL Server failover testing in a non-production pipeline.
- Add load, stress, and performance testing.
- Add automated release tags and GitHub releases.
- Add rolling, canary, or blue-green deployment options.
- Move Jenkins, SonarQube, Prometheus, and Grafana to a dedicated management subnet or separate management VNet.
- Add a separate production environment with isolated state, credentials, and approval policies.

---

## License

This project is intended for learning, demonstration, and portfolio purposes.
