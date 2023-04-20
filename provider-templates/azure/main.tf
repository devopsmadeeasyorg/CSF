# Resource Group
resource "azurerm_resource_group" "Dev_RG" {
  name     = "Dev-RG"
  location = "${var.mylocation}"
}

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

# Public ip and Network Interface for HAProxy server

resource "azurerm_public_ip" "haproxypip" {
  name                =  "haproxypip"
  location            =  azurerm_resource_group.Dev_RG.location
  resource_group_name =  azurerm_resource_group.Dev_RG.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "haproxynic" {
  name                = "haproxynic"
  location            = azurerm_resource_group.Dev_RG.location
  resource_group_name = azurerm_resource_group.Dev_RG.name

  ip_configuration {
    name                          = "haproxyconfig"
    subnet_id                     = azurerm_subnet.public_subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.haproxypip.id
  }
}

# Network interface for Webapp server
resource "azurerm_network_interface" "webappnic" {
  name                = "webappnic"
  location            = azurerm_resource_group.Dev_RG.location
  resource_group_name = azurerm_resource_group.Dev_RG.name

  ip_configuration {
    name                          = "webappconfig"
    subnet_id                     = azurerm_subnet.private_subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Network security group

resource "azurerm_network_security_group" "haproxynsg" {
  name                = "haproxynsg"
  location            = azurerm_resource_group.Dev_RG.location
  resource_group_name = azurerm_resource_group.Dev_RG.name
  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "webappnsg" {
  name                = "webappnsg"
  location            = azurerm_resource_group.Dev_RG.location
  resource_group_name = azurerm_resource_group.Dev_RG.name
  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "haproxy_nic_nsg" {
  network_interface_id      = azurerm_network_interface.haproxynic.id
  network_security_group_id = azurerm_network_security_group.haproxynsg.id
}

resource "azurerm_network_interface_security_group_association" "webapp_nic_nsg" {
  network_interface_id      = azurerm_network_interface.webappnic.id
  network_security_group_id = azurerm_network_security_group.webappnsg.id
}





