# Virtual Network
resource "azurerm_virtual_network" "Dev_VNet" {
  name                = "Dev-VNet"
  resource_group_name = azurerm_resource_group.Dev_RG.name
  location            = azurerm_resource_group.Dev_RG.location
  address_space       = ["10.0.0.0/16"]
}

# Subnets
resource "azurerm_subnet" "public_subnet1" {
  name                 = "public-subnet1"
  resource_group_name  = azurerm_resource_group.Dev_RG.name
  virtual_network_name = azurerm_virtual_network.Dev_VNet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "public_subnet2" {
  name                 = "public-subnet2"
  resource_group_name  = azurerm_resource_group.Dev_RG.name
  virtual_network_name = azurerm_virtual_network.Dev_VNet.name
  address_prefixes     = ["10.0.2.0/24"]
}


resource "azurerm_subnet" "private_subnet1" {
  name                 = "private-subnet1"
  resource_group_name  = azurerm_resource_group.Dev_RG.name
  virtual_network_name = azurerm_virtual_network.Dev_VNet.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_subnet" "private_subnet2" {
  name                 = "private-subnet2"
  resource_group_name  = azurerm_resource_group.Dev_RG.name
  virtual_network_name = azurerm_virtual_network.Dev_VNet.name
  address_prefixes     = ["10.0.4.0/24"]
}


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
    name           = "eggress-route-to-internet"
    address_prefix = "${azurerm_public_ip.ngwpip.ip_address}/32"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_public_ip.ngwpip.ip_address
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





# Public ips and Network Interfaces for Linux based Bastion host
# resource "azurerm_public_ip" "bastionpip" {
#   name                =  "bastionpip"
#   location            =  azurerm_resource_group.Dev_RG.location
#   resource_group_name =  azurerm_resource_group.Dev_RG.name
#   allocation_method   = "Dynamic"
# }

resource "azurerm_network_interface" "bastionnic" {
  name                = "bastionnic"
  location            = azurerm_resource_group.Dev_RG.location
  resource_group_name = azurerm_resource_group.Dev_RG.name

  ip_configuration {
    name                          = "bastionconfig"
    subnet_id                     = azurerm_subnet.public_subnet1.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id = azurerm_public_ip.bastionpip.id
  }
}

# Network interface for Webapp servers
resource "azurerm_network_interface" "webapp_server_1_nic" {
  name                = "webapp_server_1_nic"
  location            = azurerm_resource_group.Dev_RG.location
  resource_group_name = azurerm_resource_group.Dev_RG.name

  ip_configuration {
    name                          = "webapp_server_1_nic_config"
    subnet_id                     = azurerm_subnet.private_subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "webapp_server_2_nic" {
  name                = "webapp_server_2_nic"
  location            = azurerm_resource_group.Dev_RG.location
  resource_group_name = azurerm_resource_group.Dev_RG.name

  ip_configuration {
    name                          = "webapp_server_2_nic_config"
    subnet_id                     = azurerm_subnet.private_subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}




# NAT Gateway
resource "azurerm_nat_gateway" "myngw" {
  name                    = "myngw"
  location            = azurerm_resource_group.Dev_RG.location
  resource_group_name = azurerm_resource_group.Dev_RG.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  # zones                   = ["1"]
}

resource "azurerm_public_ip" "ngwpip" {
  name                = "ngwpip"
  location            = azurerm_resource_group.Dev_RG.location
  resource_group_name = azurerm_resource_group.Dev_RG.name
  allocation_method   = "Static"
  sku                 = "Standard"
  # zones               = ["1"]
}

resource "azurerm_nat_gateway_public_ip_association" "ngwpip" {
  nat_gateway_id       = azurerm_nat_gateway.myngw.id
  public_ip_address_id = azurerm_public_ip.ngwpip.id
}

resource "azurerm_subnet_nat_gateway_association" "ngwsubnet" {
  subnet_id      = azurerm_subnet.public_subnet2.id
  nat_gateway_id = azurerm_nat_gateway.myngw.id
}


