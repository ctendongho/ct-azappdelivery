resource "azurerm_network_interface" "sql1" {
  name                = "${var.sql_vm1_name}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.db1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "sql2" {
  name                = "${var.sql_vm2_name}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.db2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "sql1" {
  name                = var.sql_vm1_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.sql_vm_size
  admin_username      = var.sql_admin_username
  admin_password      = var.sql_admin_password
  zone                = "1"

  network_interface_ids = [
    azurerm_network_interface.sql1.id
  ]

  source_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "sql2022-ws2022"
    sku       = "sqldev-gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.main.primary_blob_endpoint
  }
}

resource "azurerm_windows_virtual_machine" "sql2" {
  name                = var.sql_vm2_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.sql_vm_size
  admin_username      = var.sql_admin_username
  admin_password      = var.sql_admin_password
  zone                = "2"

  network_interface_ids = [
    azurerm_network_interface.sql2.id
  ]

  source_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "sql2022-ws2022"
    sku       = "sqldev-gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.main.primary_blob_endpoint
  }
}
