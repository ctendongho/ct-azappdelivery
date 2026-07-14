variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
}

variable "vnet_name" {
  description = "Virtual Network name"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
}

variable "public_subnet1_name" {
  description = "Public subnet in Zone 1"
  type        = string
}

variable "public_subnet1_prefix" {
  description = "Address prefix for Public Subnet 1"
  type        = list(string)
}

variable "public_subnet2_name" {
  description = "Public subnet in Zone 2"
  type        = string
}

variable "public_subnet2_prefix" {
  description = "Address prefix for Public Subnet 2"
  type        = list(string)
}

variable "app_subnet1_name" {
  description = "Application subnet in Zone 1"
  type        = string
}

variable "app_subnet1_prefix" {
  description = "Address prefix for Application Subnet 1"
  type        = list(string)
}

variable "app_subnet2_name" {
  description = "Application subnet in Zone 2"
  type        = string
}

variable "app_subnet2_prefix" {
  description = "Address prefix for Application Subnet 2"
  type        = list(string)
}

variable "db_subnet1_name" {
  description = "Database subnet in Zone 1"
  type        = string
}

variable "db_subnet1_prefix" {
  description = "Address prefix for Database Subnet 1"
  type        = list(string)
}

variable "db_subnet2_name" {
  description = "Database subnet in Zone 2"
  type        = string
}

variable "db_subnet2_prefix" {
  description = "Address prefix for Database Subnet 2"
  type        = list(string)
}

variable "admin_public_ip" {
  description = "Administrator public IP address"
  type        = string
}

variable "management_public_ip_name" {
  description = "Public IP for the management VM"
  type        = string
}

variable "managed_identity_name" {
  description = "User Assigned Managed Identity"
  type        = string
}

variable "vmss_name" {
  description = "Application VM Scale Set name"
  type        = string
}

variable "vmss_instance_count" {
  description = "Initial number of VMSS instances"
  type        = number
}

variable "vmss_vm_size" {
  description = "Virtual machine size for the VM Scale Set"
  type        = string
}

variable "vmss_admin_username" {
  description = "Administrator username for the VM Scale Set"
  type        = string
}

variable "vmss_admin_password" {
  description = "Administrator password for the Windows VM Scale Set"
  type        = string
  sensitive   = true
}

variable "dc_vm_name" {
  description = "Domain Controller VM name"
  type        = string
}

variable "dc_vm_size" {
  description = "Domain Controller VM size"
  type        = string
}

variable "dc_admin_username" {
  description = "Domain Controller admin username"
  type        = string
}

variable "dc_admin_password" {
  description = "Domain Controller admin password"
  type        = string
  sensitive   = true
}

variable "sql_vm1_name" {
  description = "SQL Server VM in Zone 1"
  type        = string
}

variable "sql_vm2_name" {
  description = "SQL Server VM in Zone 2"
  type        = string
}

variable "sql_vm_size" {
  description = "SQL Server VM size"
  type        = string
}

variable "sql_admin_username" {
  description = "SQL Server administrator username"
  type        = string
}

variable "sql_admin_password" {
  description = "SQL Server administrator password"
  type        = string
  sensitive   = true
}

variable "root_certificate" {
  description = "VPN Root Certificate"
  type        = string
  sensitive   = true
}

# Application Gateway
variable "appgw_subnet_name" {
  default = "ct-appgwsnet"
}

variable "appgw_subnet_prefix" {
  default = ["10.10.50.0/24"]
}
