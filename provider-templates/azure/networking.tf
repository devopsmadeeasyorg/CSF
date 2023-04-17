resource "azurerm_route_table" "public_route_table" {
  name                          = "public-route-table"
  location            = azurerm_resource_group.Dev_RG.location
  resource_group_name = azurerm_resource_group.Dev_RG.name
  disable_bgp_route_propagation = false
  route {
    name           = "default"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
}

resource "azurerm_subnet_route_table_association" "pbrtba1" {
  subnet_id      = azurerm_subnet.public_subnet1.id
  route_table_id = azurerm_route_table.public_route_table.id
}

resource "azurerm_subnet_route_table_association" "pbrtba2" {
  subnet_id      = azurerm_subnet.public_subnet2.id
  route_table_id = azurerm_route_table.public_route_table.id
}



resource "azurerm_route_table" "private_route_table" {
  name                          = "private-route-table"
  location            = azurerm_resource_group.Dev_RG.location
  resource_group_name = azurerm_resource_group.Dev_RG.name
  disable_bgp_route_propagation = false
  route {
    name           = "eggress-route"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.2.6"
  }
}

resource "azurerm_subnet_route_table_association" "pvrtba1" {
  subnet_id      = azurerm_subnet.private_subnet1.id
  route_table_id = azurerm_route_table.private_route_table.id
}

resource "azurerm_subnet_route_table_association" "pvrtba2" {
  subnet_id      = azurerm_subnet.private_subnet2.id
  route_table_id = azurerm_route_table.private_route_table.id
}