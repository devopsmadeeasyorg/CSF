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





# Azure Virtual Machines
resource "azurerm_linux_virtual_machine" "haproxy" {
  name                  = "haproxy"
  location              = azurerm_resource_group.Dev_RG.location
  resource_group_name   = azurerm_resource_group.Dev_RG.name
  network_interface_ids = [azurerm_network_interface.haproxynic.id]
  size                = "Standard_F2"
  admin_username      = "adminuser"
  

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = "${var.mykey}"
  }

  os_disk {
    name = "haproxy-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  /* connection {
        host = self.public_ip_address
        user = "adminuser"
        type = "ssh"
        private_key = "${file("~/Downloads/mykp.pem")}"
        timeout = "4m"
        agent = false
    }

  provisioner "remote-exec" {
        inline = [
      "sudo apt update",

      "sudo apt install docker.io -y"
        ]
    } */
}

resource "azurerm_linux_virtual_machine" "webapp" {
  name                  = "webapp"
  location              = azurerm_resource_group.Dev_RG.location
  resource_group_name   = azurerm_resource_group.Dev_RG.name
  network_interface_ids = [azurerm_network_interface.webappnic.id]
  size                = "Standard_F2"
  admin_username      = "adminuser"
  

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = "${var.mykey}"
  }

  os_disk {
    name = "webapp-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

# Azure Load balancers
resource "azurerm_public_ip" "example" {
  name                = "PublicIPForLB"
  resource_group_name = azurerm_resource_group.Dev_RG.name
  location            = azurerm_resource_group.Dev_RG.location
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_lb" "example" {
  name                = "test-lb"
  resource_group_name = azurerm_resource_group.Dev_RG.name
  location            = azurerm_resource_group.Dev_RG.location
  sku = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

resource "azurerm_lb_rule" "example" {
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 5001
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.example.id]
}

resource "azurerm_lb_backend_address_pool" "example" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_backend_address_pool_address" "example" {
  name                    = "example"
  backend_address_pool_id = azurerm_lb_backend_address_pool.example.id
  virtual_network_id      = azurerm_virtual_network.Dev_VNet.id
  ip_address              = azurerm_linux_virtual_machine.haproxy.private_ip_address
}