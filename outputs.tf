output "vm" {
  value = "${azurerm_virtual_machine.VM}"
}

output "Nic0" {
  value = "${azurerm_network_interface.NIC}"
}
