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

# Virtual Machine Scale Set
vmss_name           = "ct-azappvmss"
vmss_instance_count = 2
vmss_vm_size        = "Standard_D2s_v3"
vmss_admin_username = "charlo"

vmss_admin_password = "ReplaceWithAStrongPassword123!"

# Domain Controller
dc_vm_name        = "ct-azappdc01"
dc_vm_size        = "Standard_D2s_v3"
dc_admin_username = "azureadmin"
dc_admin_password = "ReplaceWithAStrongPassword123!"

# SQL Server VMs
sql_vm1_name       = "ct-azappsql01"
sql_vm2_name       = "ct-azappsql02"
sql_vm_size        = "Standard_D2s_v3"
sql_admin_username = "azureadmin"
sql_admin_password = "ReplaceWithAStrongPassword123!"

root_certificate = "MIIC8zCCAdugAwIBAgIQI7YYCh7/vKBGvos6+rU0+DANBgkqhkiG9w0BAQsFADAcMRowGAYDVQQDDBFDVEludmVudG9yeVJvb3RDQTAeFw0yNjA3MTExMTM2MTFaFw0yNzA3MTExMTU2MTFaMBwxGjAYBgNVBAMMEUNUSW52ZW50b3J5Um9vdENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv17mKM3k2VjH1DfSRiIZZFpyy3kBObTkZFmNPwy9/+rABGk2URciHEvnlLeVE+CK8GbRdchALMfMz7SsLCXIJlwdUZs3YoMP1AhQs1cDPKqQCIoV/hyH8ddQHlUoAnUWyMPnyCwDYMfT2fX87LmOYmfpejSPgjZ4AA9NO8PV1jPb83Obmbuvw46qO/exLPV4GZi5ztKACuM9bRB/gZA5j/wxM9Cwmx3XfQp3xksh/7g9OQwRmTB31o7weXzkUyhGFikqke5S9VOfwYxl8PhbfVL4HFYKtUS+fkJ+D5CZZnPQiMa80XHR72hmZnGBFRc2MHj/lVC15PCTXJTbu+8qrQIDAQABozEwLzAOBgNVHQ8BAf8EBAMCAgQwHQYDVR0OBBYEFM8Wl9Xd043/EdAZ1uN4XxvHsY/9MA0GCSqGSIb3DQEBCwUAA4IBAQBDH8ud5H2GfWb/HHoekROl/Gayv7CoIe3kJ7o3ylKn6T+pcSB95fVxhEu/4XeugAgzIIBgehG1/uD+PnbeR0zHRbZJSs4e7MVEAou942d0FzGgcRLA0VXl+Fk0WBSh+1l39eWUAtEvbJD7yBpIA6idnBm40JvUVBHBw6PLAfZSKmHtYzF0H2hGLU47E3rrUB9FqeC4/tHDIzO4kpGz7vfiUBSRtgqtgx2J5oKCyJIYa4imekxJH1w52ggA2hmvuhe3otVg7HtY+KkclzceTYaD5EZgD3JERw1pqsjzQChKJMN0OF9B8MnOYcsp0x9AqC++mCsN0zANPkY9akNV8bck"
