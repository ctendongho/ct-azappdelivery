resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = var.vnet_address_space
}

resource "azurerm_public_ip" "management" {
  name                = var.management_public_ip_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  allocation_method = "Static"
  sku               = "Standard"
}

resource "azurerm_subnet" "public1" {
  name                 = var.public_subnet1_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.public_subnet1_prefix
}

resource "azurerm_subnet" "public2" {
  name                 = var.public_subnet2_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.public_subnet2_prefix
}

resource "azurerm_subnet" "app1" {
  name                 = var.app_subnet1_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.app_subnet1_prefix
}

resource "azurerm_subnet" "app2" {
  name                 = var.app_subnet2_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.app_subnet2_prefix
}

resource "azurerm_subnet" "db1" {
  name                 = var.db_subnet1_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.db_subnet1_prefix
}

resource "azurerm_subnet" "db2" {
  name                 = var.db_subnet2_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.db_subnet2_prefix
}

data "azurerm_virtual_network" "management" {
  name                = "ct-main-vnet"
  resource_group_name = "CT-AZAPP-RG"
}

resource "azurerm_virtual_network_peering" "management_to_app" {
  name                      = "ct-main-to-azapp-peer"
  resource_group_name       = data.azurerm_virtual_network.management.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.management.name
  remote_virtual_network_id = azurerm_virtual_network.main.id

  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "app_to_management" {
  name                      = "ct-azapp-to-main-peer"
  resource_group_name       = azurerm_resource_group.main.name
  virtual_network_name      = azurerm_virtual_network.main.name
  remote_virtual_network_id = data.azurerm_virtual_network.management.id

  allow_virtual_network_access = true
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.10.250.0/27"]
}

resource "azurerm_subnet" "appgw" {
  name                 = var.appgw_subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.appgw_subnet_prefix
}
