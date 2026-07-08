# Resource Group
resource_group_name = "ct-azapps-rg"
location            = "Central US"

# Virtual Network
vnet_name          = "ct-azappvnet"
vnet_address_space = ["10.10.0.0/16"]

# Public Subnet
public_subnet_name   = "ct-publicsnet01"
public_subnet_prefix = ["10.10.1.0/24"]

# Private Application Subnet
app_subnet_name   = "ct-privatesnet01"
app_subnet_prefix = ["10.10.2.0/24"]

# Private Database Subnet
db_subnet_name   = "ct-privatesnet02"
db_subnet_prefix = ["10.10.3.0/24"]
