resource "azurerm_user_assigned_identity" "main" {
  name                = var.managed_identity_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_network_interface" "dc" {
  name                = "${var.dc_vm_name}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.10.11.10"
  }
}

resource "azurerm_windows_virtual_machine" "dc" {
  name                = var.dc_vm_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.dc_vm_size
  admin_username      = var.dc_admin_username
  admin_password      = var.dc_admin_password
  network_interface_ids = [
    azurerm_network_interface.dc.id
  ]
  zone = "1"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
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

resource "azurerm_virtual_machine_extension" "dc_winrm" {
  name                 = "enable-winrm"
  virtual_machine_id   = azurerm_windows_virtual_machine.dc.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -Command \"Enable-PSRemoting -Force; Set-NetFirewallRule -DisplayGroup 'Windows Remote Management' -Enabled True; winrm quickconfig -quiet\""
  })
}
