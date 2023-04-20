output "haproxy_public_ip" {
  value = azurerm_linux_virtual_machine.haproxy.public_ip_address
}