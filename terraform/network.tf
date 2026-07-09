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
