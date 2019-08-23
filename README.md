# Terraform Basic Virtual Machine

## Introduction

This module deploys a simple [virtual machine resource](https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/2019-03-01/virtualmachines) with an NSG, 1 NIC, a simple OS Disk and optional data disks.

Optional configuration is deployed in the following order:

1. CustomScriptExtenstion
2. domainJoin
3. encryptDisks

## Security Controls

The following security controls can be met through configuration of this template:

* AC-1, AC-10, AC-11, AC-11(1), AC-12, AC-14, AC-16, AC-17, AC-18, AC-18(4), AC-2 , AC-2(5), AC-20(1) , AC-20(3), AC-20(4), AC-24(1), AC-24(11), AC-3, AC-3 , AC-3(1), AC-3(3), AC-3(9), AC-4, AC-4(14), AC-6, AC-6, AC-6(1), AC-6(10), AC-6(11), AC-7, AC-8, AC-8, AC-9, AC-9(1), AI-16, AU-2, AU-3, AU-3(1), AU-3(2), AU-4, AU-5, AU-5(3), AU-8(1), AU-9, CM-10, CM-11(2), CM-2(2), CM-2(4), CM-3, CM-3(1), CM-3(6), CM-5(1), CM-6, CM-6, CM-7, CM-7, IA-1, IA-2, IA-3, IA-4(1), IA-4(4), IA-5, IA-5, IA-5(1), IA-5(13), IA-5(1c), IA-5(6), IA-5(7), IA-9, SC-10, SC-13, SC-15, SC-18(4), SC-2, SC-2, SC-23, SC-28, SC-30(5), SC-5, SC-7, SC-7(10), SC-7(16), SC-7(8), SC-8, SC-8(1), SC-8(4), SI-14, SI-2(1), SI-3

## Dependancies

* [Resource Groups](https://github.com/canada-ca-azure-templates/resourcegroups/blob/master/readme.md)
* [Keyvault](https://github.com/canada-ca-azure-templates/keyvaults/blob/master/readme.md)
* [VNET-Subnet](https://github.com/canada-ca-azure-templates/vnet-subnet/blob/master/readme.md)

## Usage

```terraform
module "jumpbox" {
  source = "github.com/canada-ca-terraform-modules/basicwindowsvm?ref=20190819.1"

  name                              = "jumpbox"
  resource_group_name               = "some-RG-Name"
  admin_username                    = "someusername"
  secretPasswordName                = "somekeyvaultsecretname"
  nic_subnetName                    = "some-subnet-name"
  nic_vnetName                      = "some-vnet-name"
  nic_resource_group_name           = "some-vnet-resourcegroup-name"
  vm_size                           = "Standard_D2_v3"
  keyvault = {
    name                = "some-keyvault-name"
    resource_group_name = "some-keyvault-resourcegroup-name"
  }
}
```

## Variables Values

| Name                               | Type   | Required | Value                                                                                                                                                                                                       |
| ---------------------------------- | ------ | -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| name                               | string | yes      | Name of the vm                                                                                                                                                                                              |
| resource_group_name                | string | yes      | Name of the resourcegroup that will contain the VM resources                                                                                                                                                |
| admin_username                     | string | yes      | Name of the VM admin account                                                                                                                                                                                |
| secretPasswordName                 | string | yes      | Name of the Keyvault secret containing the VM admin account password                                                                                                                                        |
| nic_subnetName                     | string | yes      | Name of the subnet to which the VM NIC will connect to                                                                                                                                                      |
| nic_vnetName                       | string | yes      | Name of the VNET the subnet is part of                                                                                                                                                                      |
| nic_resource_group_name            | string | yes      | Name of the resourcegroup containing the VNET                                                                                                                                                               |
| vm_size                            | string | yes      | Specifies the desired size of the Virtual Machine. Eg: Standard_F4                                                                                                                                          |
| keyvault                           | object | yes      | Object containing keyvault resource configuration. - [keyvault](#keyvault-object)                                                                                                                           |
| location                           | string | no       | Azure location for resources. Default: canadacentral                                                                                                                                                        |
| tags                               | object | no       | Object containing a tag values - [tags pairs](#tag-object)                                                                                                                                                  |
| data_disk_sizes_gb                 | list   | no       | List of data disk sizes in gigabytes required for the VM. - [data disk](#data-disk-list)                                                                                                                    |
| dnsServers                         | list   | no       | List of DNS servers IP addresses as string to use for this NIC, overrides the VNet-level dns server list - [dns servers](#dns-servers-list)                                                                 |
| nic_enable_ip_forwarding           | bool   | no       | Enables IP Forwarding on the NIC. Default: false                                                                                                                                                            |
| nic_enable_accelerated_networkingg | bool   | no       | Enables Azure Accelerated Networking using SR-IOV. Only certain VM instance sizes are supported. Default: false                                                                                             |
| nic_ip_configuration               | object | no       | Defines how a private IP address is assigned. Options are Static or Dynamic. In case of Static also specifiy the desired privat IP address. Default: Dynamic - [ip configuration](#ip-configuration-object) |
| public_ip                          | bool   | no       | Does the VM require a public IP. true or false. Default: false                                                                                                                                              |
| storage_image_reference            | object | no       | Specify the storage image used to create the VM. Default is 2016-Datacenter. - [storage image](#storage-image-reference-object)                                                                             |
| storage_os_disk                    | object | no       | Storage OS Disk configuration. Default: ReadWrite from image.                                                                                                                                               |
| custom_data                        | string | no       | some custom ps1 code to execute. Eg: ${file("serverconfig/jumpbox-init.ps1")}                                                                                                                               |
| domainToJoin                       | object | no       | Object containing the configuration related to the Active Directory Domain to join. - [domain to join](#domain-join-object)                                                                                 |
| encryptDisk                        | bool   | no       | Configure if VM disks should be encrypted with Bitlocker. Default false                                                                                                                                     |
| monitoringAgent                    | object | no       | Configure Azure monitoring on VM. Requires configured log analytics workspace. - [monitoring agent](#monitoring-agent-object)                                                                               |
| antimalware                        | object | no       | Configure Azure antimalware on VM. - [antimalware](#antimalware-object)                                                                                                                                     |
| shutdownConfig                     | object | no       | Configure desired VM shutdown time - [shutdown config](#shutdown-config-object)                                                                                                                             |

### tag object

Example tag variable:

```hcl
tags = {
  "tag1name" = "somevalue"
  "tag2name" = "someothervalue"
  .
  .
  .
  "tagXname" = "some other value"
}
```

### data disk list

Example data_disk_size_gb variable. The following example would deploy 3 data disks. One one of 40GB, one of 100GB and a last of 60GB:

```hcl
data_disk_size_gb = [40,100,60]
```

### dns servers list

Example dnsServers variable. The following example would configure 2 dns servers:

```hcl
dnsServers = ["10.20.30.40","10.20.30.41]
```

### ip configuration object

| Name                          | Type   | Required | Value                                           |
| ----------------------------- | ------ | -------- | ----------------------------------------------- |
| private_ip_address            | string | yes      | Static IP desired. Set to null if using Dynamic |
| private_ip_address_allocation | string | yes      | Set to either Dynamic or Static                 |

Example variable for static ip:

```hcl
nic_ip_configuration = {
  private_ip_address            = "10.20.30.42"
  private_ip_address_allocation = "Static"
}
```

### #storage image reference object

| Name      | Type       | Required           | Value                                                                                              |
| --------- | ---------- | ------------------ | -------------------------------------------------------------------------------------------------- |
| publisher | string     | yes                | The image publisher.                                                                               |
| offer     | string     | yes                | Specifies the offer of the platform image or marketplace image used to create the virtual machine. |
| sku       | string     | yes                | The image SKU.                                                                                     |
| version   | string yes | The image version. |

Example variable:

```hcl
storage_image_reference = {
  publisher = "MicrosoftWindowsServer"
  offer     = "WindowsServer"
  sku       = "2016-Datacenter"
  version   = "latest"
}
```

### keyvault object

| Name                | Type   | Required | Value                                                    |
| ------------------- | ------ | -------- | -------------------------------------------------------- |
| name                | string | yes      | Name of the keyvault resource                            |
| resource_group_name | string | yes      | Name of the resource group where the keyvault is located |

Example variable:

```hcl
keyvault = {
  name                = "some-keyvault-name"
  resource_group_name = "some-resource-group-name"
}
```

### domain join object

| Name                 | Type    | Required | Value                                                       |
| -------------------- | ------- | -------- | ----------------------------------------------------------- |
| domainToJoin         | string  | Yes      | Name of the domain to join. Eg. test.gc.ca.local            |
| domainUsername       | string  | Yes      | Name of domain admin account to use to join the domain      |
| domainUserSecretName | string  | Yes      | Name of secret containing the domain admin account password |
| domainJoinOptions    | integer | Yes      | Domain join option. Recommended value: 3                    |
| ouPath               | string  | Yes      | Path for the domain ou. Leave empty in most cases. Eg: ""   |

Example variable:

```hcl
domainToJoin = {
  domainName           = "test.com"
  domainUsername       = "azureadmin"
  domainUserSecretName = "adDefaultPassword"
  domainJoinOptions    = 3
  ouPath               = ""
}
```

### monitoring agent object

| Name                                        | Type   | Required | Value                                                                |
| ------------------------------------------- | ------ | -------- | -------------------------------------------------------------------- |
| log_analytics_workspace_name                | string | Yes      | Name of the log analytics workspace that the VM will send logs to.   |
| log_analytics_workspace_resource_group_name | string | Yes      | Name of the resource group that contain the log analytics workspace. |

Example variable:

```hcl
monitoringAgent = {
  log_analytics_workspace_name                = "somename"
  log_analytics_workspace_resource_group_name = "someRGName"
}
```

### antimalware object

| Name                         | Type   | Required | Value                                                                                                                       |
| ---------------------------- | ------ | -------- | --------------------------------------------------------------------------------------------------------------------------- |
| RealtimeProtectionEnabled    | string | Yes      | Indicates whether or not real time protection is enabled - true or false                                                    |
| ScheduledScanSettingsEnabled | string | Yes      | Indicates whether or not custom scheduled scan settings are enabled - true or false                                         |
| ScheduledScanSettingsDay     | string | Yes      | Day of the week for scheduled scan (1-Sunday, 2-Monday, ..., 7-Saturday)                                                    |
| ScheduledScanSettingsTime    | string | Yes      | When to perform the scheduled scan, measured in minutes from midnight (0-1440). For example: 0 = 12AM, 60 = 1AM, 120 = 2AM. |
| ScheduledScanSettingsType    | string | Yes      | Indicates whether scheduled scan setting type is set to Quick or Full - Quick or Full                                       |
| ExclusionExtensions          | string | Yes      | Semicolon delimited list of file extensions to exclude from scanning. Eg: .txt; .ps1                                        |
| ExclusionPaths               | string | Yes      | Semicolon delimited list of file paths or locations to exclude from scanning. Eg: c:\\Users                                 |
| ExclusionProcesses           | string | Yes      | Semicolon delimited list of process names to exclude from scanning. Eg: w3wp.exe;explorer.exe                               |

Example variable:

```hcl
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
```

### shutdown config object

| Name                           | Type   | Required | Value                                                                                          |
| ------------------------------ | ------ | -------- | ---------------------------------------------------------------------------------------------- |
| autoShutdownStatus             | string | Yes      | Name of the VM                                                                                 |
| autoShutdownTime               | string | Yes      | The time of day the schedule will occur. Eg: 17:00                                             |
| autoShutdownTimeZone           | string | Yes      | Timezone ID. Eg: Eastern Standard Time                                                         |
| autoShutdownNotificationStatus | string | Yes      | If notifications are enabled for this schedule (i.e. Enabled, Disabled). - Enabled or Disabled |

Example variable:

```hcl
shutdownConfig = {
  autoShutdownStatus = "Enabled"
  autoShutdownTime = "17:00"
  autoShutdownTimeZone = "Eastern Standard Time"
  autoShutdownNotificationStatus = "Disabled"
}
```

## History

| Date     | Release    | Change                                                                            |
| -------- | ---------- | --------------------------------------------------------------------------------- |
| 20190823 |            | Update documentation                                                              |
| 20190819 | 20190819.1 | Add support for one or more managed data disks of configurable size               |
| 20190813 | 20190813.1 | Add support for joining VM to Active Directory domain                             |
| 20190812 | 20190812.1 | Improve documentation. Add testing of module. Improve module dependancy solution. |
| 20190806 | 20190806.1 | Add custom dns servers support                                                    |
| 20190729 | 20190729.1 | Fix bug where custo-script would not properly be installed                        |
| 20190725 | 20190725.1 | 1st deploy                                                                        |
