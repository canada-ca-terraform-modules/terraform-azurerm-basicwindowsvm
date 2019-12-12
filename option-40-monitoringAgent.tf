/*
Example:

monitoringAgent = {
  log_analytics_workspace_name                = "somename"
  log_analytics_workspace_resource_group_name = "someRGName"
}

*/

variable "monitoringAgent" {
  description = "Should the VM be monitored"
  default     = null
}

data "azurerm_log_analytics_workspace" "logAnalyticsWS" {
  count               = var.monitoringAgent == null ? 0 : 1
  name                = var.monitoringAgent.log_analytics_workspace_name
  resource_group_name = var.monitoringAgent.log_analytics_workspace_resource_group_name
  depends_on          = [var.vm_depends_on]
}

resource "azurerm_virtual_machine_extension" "MicrosoftMonitoringAgent" {
  count                      = var.monitoringAgent == null ? 0 : 1
  name                       = "MicrosoftMonitoringAgent"
  depends_on                 = [azurerm_virtual_machine_extension.DAAgentForWindows]
  location                   = var.location
  resource_group_name        = var.resource_group_name
  virtual_machine_name       = azurerm_virtual_machine.VM.name
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
        {  
          "workspaceId": "${data.azurerm_log_analytics_workspace.logAnalyticsWS[0].workspace_id}"
        }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
        {
          "workspaceKey": "${data.azurerm_log_analytics_workspace.logAnalyticsWS[0].primary_shared_key}"
        }
  PROTECTED_SETTINGS

  tags = var.tags
}
