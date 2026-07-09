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

variable "public_subnet_name" {
  description = "Public subnet name"
  type        = string
}

variable "public_subnet_prefix" {
  description = "Address prefix for the public subnet"
  type        = list(string)
}

variable "app_subnet_name" {
  description = "Application subnet name"
  type        = string
}

variable "app_subnet_prefix" {
  description = "Address prefix for the application subnet"
  type        = list(string)
}

variable "db_subnet_name" {
  description = "Database subnet name"
  type        = string
}

variable "db_subnet_prefix" {
  description = "Address prefix for the database subnet"
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
