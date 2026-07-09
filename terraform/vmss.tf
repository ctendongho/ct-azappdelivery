resource "azurerm_windows_virtual_machine_scale_set" "app" {
  name                 = var.vmss_name
  computer_name_prefix = "azapp"
  resource_group_name  = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location
  sku                  = var.vmss_vm_size
  instances            = var.vmss_instance_count
  admin_username       = var.vmss_admin_username
  admin_password       = var.vmss_admin_password
  zones                = ["1", "2"]

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.main.id]
  }

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

  network_interface {
    name    = "${var.vmss_name}-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.app1.id
    }
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.main.primary_blob_endpoint
  }
}
