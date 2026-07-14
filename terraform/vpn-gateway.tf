resource "azurerm_public_ip" "vpn_gateway" {
  name                = "ct-vpngateway-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  allocation_method = "Static"
  sku               = "Standard"
  zones             = ["1", "2", "3"]
}

resource "azurerm_virtual_network_gateway" "main" {
  name                = "ct-vpngateway"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  type     = "Vpn"
  vpn_type = "RouteBased"
  sku      = "VpnGw1AZ"

  active_active = false
  bgp_enabled   = false

  ip_configuration {
    name                          = "ct-vpngateway-ipconfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway.id
  }

  vpn_client_configuration {
    address_space = [
      "172.20.20.0/24"
    ]

    vpn_client_protocols = [
      "OpenVPN"
    ]

    root_certificate {
      name             = "CTInventoryRootCA"
      public_cert_data = var.root_certificate
    }
  }
}
