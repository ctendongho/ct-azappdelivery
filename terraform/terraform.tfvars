# Resource Group
resource_group_name = "ct-azapps-rg"
location            = "Central US"

# Virtual Network
vnet_name          = "ct-azappvnet"
vnet_address_space = ["10.10.0.0/16"]

# Public Subnets
public_subnet1_name   = "ct-publicsnet01"
public_subnet1_prefix = ["10.10.1.0/24"]

public_subnet2_name   = "ct-publicsnet02"
public_subnet2_prefix = ["10.10.2.0/24"]

# Application Subnets
app_subnet1_name   = "ct-appsnet01"
app_subnet1_prefix = ["10.10.11.0/24"]

app_subnet2_name   = "ct-appsnet02"
app_subnet2_prefix = ["10.10.12.0/24"]

# Database Subnets
db_subnet1_name   = "ct-dbsnet01"
db_subnet1_prefix = ["10.10.21.0/24"]

db_subnet2_name   = "ct-dbsnet02"
db_subnet2_prefix = ["10.10.22.0/24"]

admin_public_ip = "20.118.28.9/32"

management_public_ip_name = "ct-azappmain-pip"

managed_identity_name = "ct-azapp-mi"
