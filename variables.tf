variable "location" {
  description = "Location of VM"
  default     = "canadacentral"
}

variable "tags" {
  description = "Tags that will be associated to VM resources"
  default = {
    "exampleTag1" = "SomeValue1"
    "exampleTag1" = "SomeValue2"
  }
}

variable "name" {
  description = "Name of the linux vm"
}

variable "nic_subnetName" {
  description = "Name of the subnet to which the VM NIC will connect to"
}

variable "nic_vnetName" {
  description = "Name of the VNET the subnet is part of"
}
variable "nic_resource_group_name" {
  description = "Name of the resourcegroup containing the VNET"
}
variable "dnsServers" {
  description = "List of DNS servers IP addresses to use for this NIC, overrides the VNet-level server list"
  default     = null
}
variable "nic_enable_ip_forwarding" {
  description = "Enables IP Forwarding on the NIC."
  default     = false
}
variable "nic_enable_accelerated_networking" {
  description = "Enables Azure Accelerated Networking using SR-IOV. Only certain VM instance sizes are supported."
  default     = false
}
variable "nic_ip_configuration" {
  description = "Defines how a private IP address is assigned. Options are Static or Dynamic. In case of Static also specifiy the desired privat IP address"
  default = {
    private_ip_address            = null
    private_ip_address_allocation = "Dynamic"
  }
}

variable "public_ip" {
  description = "Does the VM require a public IP. True or false."
  default = false
}


variable "resource_group_name" {
  description = "Name of the resourcegroup that will contain the VM resources"
}

variable "admin_username" {
  description = "Name of the VM admin account"
}

variable "secretPasswordName" {
  description = "Name of the secret containing the VM admin account password"
}

variable "vm_size" {
  description = "Specifies the size of the Virtual Machine. Eg: Standard_F4"
}

variable "storage_image_reference" {
  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

variable "storage_os_disk" {
  default = {
    caching       = "ReadWrite"
    create_option = "FromImage"
    os_type       = null
  }
}

variable "keyvault" {
  description = "This block describe the keyvault resource name and resourcegroup name containing the keyvault"
  default = {
    name                = ""
    resource_group_name = ""
  }
}

/*
List of option related variables:

custom_data = "some custom ps1 code to execute. Eg: ${file("serverconfig/jumpbox-init.ps1")}"

domainToJoin = {
    domainName           = "test.com"
    domainUsername       = "azureadmin"
    domainUserSecretName = "adDefaultPassword"
    domainJoinOptions    = 3
    ouPath               = ""

encryptDisks = true

monitoringAgent = {
  log_analytics_workspace_name = "somename"
  log_analytics_workspace_resource_group_name = "someRGName"
}

antimalware" {
  RealtimeProtectionEnabled      = "true"
  ScheduledScanSettingsIsEnabled = "false"
  ScheduledScanSettingsDay       = "7"
  ScheduledScanSettingsTime      = "120"
  ScheduledScanSettingsScanType  = "Quick"
  ExclusionsExtensions           = ""
  ExclusionsPaths                = ""
  ExclusionsProcesses            = ""
}

shutdownConfig = {
  autoShutdownStatus = "Enabled"
  autoShutdownTime = "17:00"
  autoShutdownTimeZone = "Eastern Standard Time"
  autoShutdownNotificationStatus = "Disabled"
}

Those can be set optionally if you want to deploy with optional features
*/