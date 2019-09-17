terraform {
  required_version = ">= 0.12.1"
}
provider "azurerm" {
  version = ">= 1.32.0"
}

locals {
  template_name = "basicwindowvm"
}

data "azurerm_client_config" "current" {}

module "test-basicvm" {
  source = "../."

  name                    = "test1"
  resource_group_name     = "${azurerm_resource_group.test-RG.name}"
  admin_username          = "azureadmin"
  admin_password          = "${azurerm_key_vault_secret.serverPassword.value}"
  custom_data             = "${file("serverconfig/test-init.ps1")}"
  nic_subnetName          = "${azurerm_subnet.subnet1.name}"
  nic_vnetName            = "${azurerm_virtual_network.test-VNET.name}"
  nic_resource_group_name = "${azurerm_resource_group.test-RG.name}"
  public_ip               = true
  vm_size                 = "Standard_B4ms"
  data_disk_sizes_gb      = [40, 60]
  storage_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

module "test-basicvm2" {
  source = "../."

  vm_depends_on                     = ["${module.test-basicvm.vm}"]
  name                              = "test2"
  resource_group_name               = "${azurerm_resource_group.test-RG.name}"
  admin_username                    = "azureadmin"
  admin_password          = "${azurerm_key_vault_secret.serverPassword.value}"
  nic_subnetName                    = "${azurerm_subnet.subnet1.name}"
  nic_vnetName                      = "${azurerm_virtual_network.test-VNET.name}"
  nic_resource_group_name           = "${azurerm_resource_group.test-RG.name}"
  dnsServers                        = ["168.63.129.16"]
  nic_enable_ip_forwarding          = false
  nic_enable_accelerated_networking = false
  nic_ip_configuration = {
    private_ip_address            = ["10.10.10.10"]
    private_ip_address_allocation = ["Static"]
  }
  vm_size = "Standard_B4ms"
}

module "test-basicvm3" {
  source = "../."

  vm_depends_on           = ["${module.test-basicvm.vm}"]
  name                    = "test3"
  resource_group_name     = "${azurerm_resource_group.test-RG.name}"
  admin_username          = "azureadmin"
  admin_password          = "${azurerm_key_vault_secret.serverPassword.value}"
  nic_subnetName          = "${azurerm_subnet.subnet1.name}"
  nic_vnetName            = "${azurerm_virtual_network.test-VNET.name}"
  nic_resource_group_name = "${azurerm_resource_group.test-RG.name}"
  public_ip               = true
  nic_ip_configuration = {
    private_ip_address            = ["10.10.10.5",null,null]
    private_ip_address_allocation = ["Static","Dynamic","Dynamic"]
  }
  vm_size = "Standard_B4ms"
  encryptDisks = {
    KeyVaultResourceId = "${azurerm_key_vault.test-keyvault.id}"
    KeyVaultURL        = "${azurerm_key_vault.test-keyvault.vault_uri}"
  }
}
