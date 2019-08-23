/*
Example of domain to join variable declaration:

domainToJoin = {
  domainName           = "test.com"
  domainUsername       = "azureadmin"
  domainUserSecretName = "adDefaultPassword"
  domainJoinOptions    = 3
  ouPath               = ""
}

*/

variable "domainToJoin" {
  description = "Object containing the parameters for the domain to join"
  default     = null
}

data "azurerm_key_vault_secret" "domainPassword" {
  count        = "${var.domainToJoin == null ? 0 : 1}"
  name         = "${var.domainToJoin.domainUserSecretName}"
  key_vault_id = "${data.azurerm_key_vault.keyvaultsecrets.id}"
}

resource "azurerm_virtual_machine_extension" "DomainJoinExtension" {

  count                = "${var.domainToJoin == null ? 0 : 1}"
  name                 = "DomainJoinExtension"
  depends_on           = ["azurerm_virtual_machine_extension.CustomScriptExtension"]
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group_name}"
  virtual_machine_name = "${azurerm_virtual_machine.VM.name}"
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"

  settings = <<SETTINGS
        {  
          "Name": "${var.domainToJoin.domainName}",
          "OUPath": "${var.domainToJoin.ouPath}",
          "User": "${var.domainToJoin.domainName}\\${var.domainToJoin.domainUsername}",
          "Restart": "true",
          "Options": "${var.domainToJoin.domainJoinOptions}"
        }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
        {
          "Password": "${data.azurerm_key_vault_secret.domainPassword[0].value}"
        }
  PROTECTED_SETTINGS

  tags = "${var.tags}"
}
