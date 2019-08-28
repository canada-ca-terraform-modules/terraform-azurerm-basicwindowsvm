resource azurerm_network_security_group NSG {
  name                = "${var.name}-NSG"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  security_rule {
    name                       = "AllowAllInbound"
    description                = "Allow all in"
    access                     = "Allow"
    priority                   = "100"
    protocol                   = "*"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowAllOutbound"
    description                = "Allow all out"
    access                     = "Allow"
    priority                   = "105"
    protocol                   = "*"
    direction                  = "Outbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "*"
    destination_address_prefix = "*"
  }
  tags = "${var.tags}"
}

# If public_ip is true then create resource. If not then do not create any
resource azurerm_public_ip VM-EXT-PubIP {
  count               = var.public_ip ? length(var.nic_ip_configuration.private_ip_address_allocation) : 0
  name                = "${var.name}-EXT-PubIP${count.index + 1}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = "${var.tags}"
}

resource azurerm_network_interface NIC {
  name                          = "${var.name}-Nic1"
  location                      = "${var.location}"
  resource_group_name           = "${var.resource_group_name}"
  enable_ip_forwarding          = "${var.nic_enable_ip_forwarding}"
  enable_accelerated_networking = "${var.nic_enable_accelerated_networking}"
  network_security_group_id     = "${azurerm_network_security_group.NSG.id}"
  dns_servers                   = "${var.dnsServers}"
  dynamic "ip_configuration" {
    for_each = var.nic_ip_configuration.private_ip_address_allocation
    content {
      name                          = "ipconfig${ip_configuration.key + 1}"
      subnet_id                     = data.azurerm_subnet.subnet.id
      private_ip_address            = var.nic_ip_configuration.private_ip_address[ip_configuration.key]
      private_ip_address_allocation = var.nic_ip_configuration.private_ip_address_allocation[ip_configuration.key]
      public_ip_address_id          = var.public_ip ? azurerm_public_ip.VM-EXT-PubIP[ip_configuration.key].id : ""
      primary                       = ip_configuration.key == 0 ? true : false
    }
  }
  tags = "${var.tags}"
}

resource azurerm_virtual_machine VM {
  name                             = "${var.name}"
  depends_on                       = [var.vm_depends_on]
  location                         = "${var.location}"
  resource_group_name              = "${var.resource_group_name}"
  vm_size                          = "${var.vm_size}"
  network_interface_ids            = ["${azurerm_network_interface.NIC.id}"]
  primary_network_interface_id     = "${azurerm_network_interface.NIC.id}"
  delete_data_disks_on_termination = "true"
  delete_os_disk_on_termination    = "true"
  os_profile {
    computer_name  = "${var.name}"
    admin_username = "${var.admin_username}"
    admin_password = "${data.azurerm_key_vault_secret.secretPassword.value}"
    custom_data    = "${var.custom_data}"
  }
  storage_image_reference {
    publisher = "${var.storage_image_reference.publisher}"
    offer     = "${var.storage_image_reference.offer}"
    sku       = "${var.storage_image_reference.sku}"
    version   = "${var.storage_image_reference.version}"
  }
  os_profile_windows_config {
    provision_vm_agent = true
  }
  storage_os_disk {
    name          = "${var.name}-OsDisk_1"
    caching       = "${var.storage_os_disk.caching}"
    create_option = "${var.storage_os_disk.create_option}"
    os_type       = "${var.storage_os_disk.os_type}"
    disk_size_gb  = "${var.storage_os_disk.disk_size_gb}"
  }
  # This is where the magic to dynamically create storage disk operate
  dynamic "storage_data_disk" {
    for_each = "${var.data_disk_sizes_gb}"
    content {
      name          = "${var.name}-DataDisk_${storage_data_disk.key + 1}"
      create_option = "Empty"
      lun           = "${storage_data_disk.key}"
      disk_size_gb  = "${storage_data_disk.value}"
      caching       = "ReadWrite"
    }
  }
  tags = "${var.tags}"
}
