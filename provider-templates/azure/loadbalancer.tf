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
  sku = "Standard"

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
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend_pool.id]
}

# resource "azurerm_lb_backend_address_pool" "example" {
#   loadbalancer_id = azurerm_lb.example.id
#   name            = "BackEndAddressPool"
# }

# resource "azurerm_lb_backend_address_pool_address" "example" {
#   name                    = "example"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.example.id
#   virtual_network_id      = azurerm_virtual_network.Dev_VNet.id
#   ip_address              = azurerm_linux_virtual_machine.bastion.private_ip_address
# }

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "BackendPool"
}

resource "azurerm_lb_backend_address_pool_address" "webapplbaddress1" {
  name                    = "webapplbaddress1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
  virtual_network_id      = azurerm_virtual_network.Dev_VNet.id
  ip_address              = azurerm_linux_virtual_machine.webapp_server_1.private_ip_address
}

resource "azurerm_lb_backend_address_pool_address" "webapplbaddress2" {
  name                    = "webapplbaddress2"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
  virtual_network_id      = azurerm_virtual_network.Dev_VNet.id
  ip_address              = azurerm_linux_virtual_machine.webapp_server_2.private_ip_address
}
