output "vm" {
  value = azurerm_virtual_machine.VM
}

output "Nic0" {
  value = azurerm_network_interface.NIC
}

output "pip" {
  value = azurerm_public_ip.VM-EXT-PubIP
}

output "nic" {
  value = azurerm_network_interface.NIC
}