# Azure Virtual Machines
resource "azurerm_linux_virtual_machine" "haproxy" {
  name                  = "bastionhost"
  location              = azurerm_resource_group.Dev_RG.location
  resource_group_name   = azurerm_resource_group.Dev_RG.name
  network_interface_ids = [azurerm_network_interface.haproxynic.id]
  size                = "Standard_F2"
  admin_username      = "azure-user"
  

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "16.04-LTS"
#     version   = "latest"
#   }
 
 source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_9"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "azure-user"
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
  admin_username      = "azure-user"
  

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "16.04-LTS"
#     version   = "latest"
#   }
  
 source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_9"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "azure-user"
    public_key = "${var.mykey}"
  }

  os_disk {
    name = "webapp-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

# Azure Load balancers
resource "azurerm_public_ip" "lbpip" {
  name                = "LBpip"
  resource_group_name = azurerm_resource_group.Dev_RG.name
  location            = azurerm_resource_group.Dev_RG.location
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_lb" "example" {
  name                = "LB"
  resource_group_name = azurerm_resource_group.Dev_RG.name
  location            = azurerm_resource_group.Dev_RG.location
  # sku = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lbpip.id
  }
}

resource "azurerm_lb_rule" "example" {
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 8000
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

resource "azurerm_lb_backend_address_pool" "webapplb" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "WebappBackEndAddressPool"
}

resource "azurerm_lb_backend_address_pool_address" "webapplbaddress" {
  name                    = "webapplbpooladrress"
  backend_address_pool_id = azurerm_lb_backend_address_pool.webapplb.id
  virtual_network_id      = azurerm_virtual_network.Dev_VNet.id
  ip_address              = azurerm_linux_virtual_machine.webapp.private_ip_address
}
