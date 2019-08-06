variable "location" {
  description = "Location of the network"
  default     = "canadacentral"
}

variable "tags" {
  default = {
    "Organizations"     = "PwP0-CCC-E&O"
    "DeploymentVersion" = "2018-12-14-01"
    "Classification"    = "Unclassified"
    "Enviroment"        = "Sandbox"
    "CostCenter"        = "PwP0-EA"
    "Owner"             = "cloudteam@tpsgc-pwgsc.gc.ca"
  }
}

variable "name" {
  default = "test"
}

variable "nic_subnetName" {
  default = "PwS3-Shared-PAZ-Openshift-RG"
}

variable "nic_vnetName" {
  default = "PwS3-Infra-NetShared-VNET"
}
variable "nic_resource_group_name" {
  default = "PwS3-Infra-NetShared-RG"
}
variable "nic_enable_ip_forwarding" {
  default = false
}
variable "nic_enable_accelerated_networking" {
  default = false
}
variable "dnsServers" {
  default = ""
}
variable "nic_ip_configuration" {
  default = {
    private_ip_address            = "null"
    private_ip_address_allocation = "Dynamic"
  }
}

variable "resource_group_name" {
  default = "PwS3-GCInterrop-Openshift"
}

variable "admin_username" {
  default = "azureadmin"
}

variable "secretPasswordName" {
  default = "linuxDefaultPassword"
}

variable "custom_data" {
  default = ""
}

variable "vm_size" {
  default = "Standard_F4"
}

variable "storage_image_reference" {
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

variable "storage_os_disk" {
  default = {
    caching       = "ReadWrite"
    create_option = "FromImage"
    os_type       = "Windows"
  }
}

variable "keyvault" {
  default = {
    name                = "PwS3-Infra-KV-simc2atbrf"
    resource_group_name = "PwS3-Infra-Keyvault-RG"
  }
}
