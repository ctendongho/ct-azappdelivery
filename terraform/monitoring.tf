resource "azurerm_log_analytics_workspace" "main" {
  name                = "ct-azapp-law"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku               = "PerGB2018"
  retention_in_days = 30

  tags = {
    Project     = "CT Inventory Tracker"
    Environment = "Development"
  }
}

resource "azurerm_application_insights" "main" {
  name                = "ct-azapp-appinsights"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  workspace_id     = azurerm_log_analytics_workspace.main.id
  application_type = "web"

  tags = {
    Project     = "CT Inventory Tracker"
    Environment = "Development"
  }
}

resource "azurerm_monitor_diagnostic_setting" "application_gateway" {
  name                       = "ct-appgateway-diagnostics"
  target_resource_id         = azurerm_application_gateway.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  log_analytics_destination_type = "Dedicated"

  enabled_log {
    category = "ApplicationGatewayAccessLog"
  }

  enabled_log {
    category = "ApplicationGatewayFirewallLog"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

