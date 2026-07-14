resource "azurerm_virtual_machine_scale_set_extension" "iis_bootstrap" {
  name                         = "ct-iis-bootstrap"
  virtual_machine_scale_set_id = azurerm_windows_virtual_machine_scale_set.app.id

  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    commandToExecute = "powershell.exe -ExecutionPolicy Bypass -Command \"Install-WindowsFeature Web-Server,Web-Mgmt-Tools,Web-Asp-Net45 -IncludeManagementTools; New-Item -ItemType Directory -Path 'C:\\inetpub\\wwwroot\\health' -Force | Out-Null; Set-Content -Path 'C:\\inetpub\\wwwroot\\health\\index.html' -Value 'Healthy'; Set-Content -Path 'C:\\inetpub\\wwwroot\\index.html' -Value ('<html><head><title>CT Inventory Portal</title></head><body><h1>CT Inventory Portal</h1><p>Application server: ' + $env:COMPUTERNAME + '</p></body></html>'); if (-not (Get-NetFirewallRule -DisplayName 'Allow HTTP 80' -ErrorAction SilentlyContinue)) { New-NetFirewallRule -DisplayName 'Allow HTTP 80' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 80 -Profile Any }; Set-Service W3SVC -StartupType Automatic; Start-Service W3SVC\""
  })
}
