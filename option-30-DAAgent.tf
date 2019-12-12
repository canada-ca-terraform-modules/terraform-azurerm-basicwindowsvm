/* required for service map to work */
variable "dependancyAgent" {
  description = "Should the VM be include the dependancy agent"
  default     = null
}

resource "azurerm_virtual_machine_extension" "DAAgentForWindows" {
  count                      = var.dependancyAgent == null ? 0 : 1
  name                       = "DAAgentForWindows"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  virtual_machine_name       = azurerm_virtual_machine.VM.name
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.5"
  auto_upgrade_minor_version = true
  depends_on                 = [azurerm_virtual_machine_extension.DomainJoinExtension]
  tags = var.tags
}