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
