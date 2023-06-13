output "LB_public_ip" {
  value = azurerm_public_ip.lbpip.ip_address
}

# output "bastionhost_public_ip" {
#   value = "eval `ssh-agent` && ssh-add -k ~/.ssh/id_rsa && ssh -A azure-user@${azurerm_linux_virtual_machine.bastion.public_ip_address}"
# }

# output "webapp_private_ip" {
#   # value = azurerm_linux_virtual_machine.webapp.private_ip
#   value = "ssh azure-user${azurerm_linux_virtual_machine.webapp.private_ip}"
# }

