resource "azurerm_subnet_network_security_group_association" "private_subnet1_webappnsg" {
  subnet_id                 = azurerm_subnet.private_subnet1.id
  network_security_group_id = azurerm_network_security_group.webappnsg.id
}

resource "azurerm_subnet_network_security_group_association" "private_subnet2_webappnsg" {
  subnet_id                 = azurerm_subnet.private_subnet2.id
  network_security_group_id = azurerm_network_security_group.webappnsg.id
}