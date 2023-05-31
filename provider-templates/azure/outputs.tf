output "LB_public_ip" {
  value = azurerm_public_ip.lbpip.ip_address
}

output "bastionhost_public_ip" {
  value = azurerm_linux_virtual_machine.bastion.public_ip_address
}