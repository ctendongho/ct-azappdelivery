resource "azurerm_public_ip" "appgw" {
  name                = "ct-appgw-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  allocation_method = "Static"
  sku               = "Standard"
  zones             = ["1", "2", "3"]

  domain_name_label = "ctinventorytracker"
}

resource "azurerm_web_application_firewall_policy" "appgw" {
  name                = "ct-appgw-waf-policy"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  policy_settings {
    enabled                     = true
    mode                        = "Detection"
    request_body_check          = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
}

resource "azurerm_application_gateway" "main" {
  name                = "ct-appgateway"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  zones = ["1", "2", "3"]

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.appgw.id]
  }

  firewall_policy_id                = azurerm_web_application_firewall_policy.appgw.id
  force_firewall_policy_association = true

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "ct-appgateway-ipconfig"
    subnet_id = azurerm_subnet.appgw.id
  }

  frontend_ip_configuration {
    name                 = "ct-appgateway-frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  frontend_port {
    name = "ct-appgateway-http-port"
    port = 80
  }

  backend_address_pool {
    name = "ct-appgateway-backend-pool"

    ip_addresses = [
      "10.10.11.4",
      "10.10.11.5"
    ]
  }

  probe {
    name                                      = "ct-appgateway-health-probe"
    protocol                                  = "Http"
    host                                      = "127.0.0.1"
    path                                      = "/health"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = false

    match {
      status_code = ["200-399"]
    }
  }

  backend_http_settings {
    name                  = "ct-appgateway-http-settings"
    cookie_based_affinity = "Disabled"
    protocol              = "Http"
    port                  = 80
    request_timeout       = 30
    probe_name            = "ct-appgateway-health-probe"
  }

  http_listener {
    name                           = "ct-appgateway-http-listener"
    frontend_ip_configuration_name = "ct-appgateway-frontend-ip"
    frontend_port_name             = "ct-appgateway-http-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "ct-appgateway-http-rule"
    rule_type                  = "Basic"
    http_listener_name         = "ct-appgateway-http-listener"
    backend_address_pool_name  = "ct-appgateway-backend-pool"
    backend_http_settings_name = "ct-appgateway-http-settings"
    priority                   = 100
  }
}
