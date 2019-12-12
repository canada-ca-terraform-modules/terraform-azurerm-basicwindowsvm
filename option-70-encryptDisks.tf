/*
Example:

encryptDisks = {
  KeyVaultResourceId = "${azurerm_key_vault.test-keyvault.id}"
  KeyVaultURL        = "${azurerm_key_vault.test-keyvault.vault_uri}"
}

*/

variable "encryptDisks" {
  description = "Should the VM disks be encrypted"
  default     = null
}

resource "azurerm_virtual_machine_extension" "AzureDiskEncryption" {
  count                      = var.encryptDisks == null ? 0 : 1
  name                       = "AzureDiskEncryption"
  depends_on                 = [azurerm_template_deployment.autoshutdown]
  location                   = var.location
  resource_group_name        = var.resource_group_name
  virtual_machine_name       = azurerm_virtual_machine.VM.name
  publisher                  = "Microsoft.Azure.Security"
  type                       = "AzureDiskEncryption"
  type_handler_version       = "2.2"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
        {  
          "EncryptionOperation": "EnableEncryption",
          "KeyVaultResourceId": "${var.encryptDisks.KeyVaultResourceId}",
          "KeyVaultURL": "${var.encryptDisks.KeyVaultURL}",
          "KeyEncryptionAlgorithm": "RSA-OAEP",
          "VolumeType": "All",
          "ResizeOSDisk": false
        }
  SETTINGS

  tags = var.tags
}
