########### Azure Virtual Machines #####################
resource "azurerm_linux_virtual_machine" "webapp_server_1" {
  name                  = "webapp-server-1"
  location              = azurerm_resource_group.Dev_RG.location
  resource_group_name   = azurerm_resource_group.Dev_RG.name
  network_interface_ids = [azurerm_network_interface.webapp_server_1_nic.id]
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
    name = "webapp-server-1-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_linux_virtual_machine" "webapp_server_2" {
  name                  = "webapp-server-2"
  location              = azurerm_resource_group.Dev_RG.location
  resource_group_name   = azurerm_resource_group.Dev_RG.name
  network_interface_ids = [azurerm_network_interface.webapp_server_2_nic.id]
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
    name = "webapp-server-2-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}



################### Azure Virtual Machines using Virtual Machine Scale Sets ###########
# resource "azurerm_virtual_machine_scale_set" "vmss" {
#  name                = "vmscaleset"
#  location              = azurerm_resource_group.Dev_RG.location
#  resource_group_name   = azurerm_resource_group.Dev_RG.name
#  upgrade_policy_mode = "Manual"

#  sku {
#    name     = "Standard_DS1_v2"
#    tier     = "Standard"
#    capacity = 2
#  }

#  storage_profile_image_reference {
#    publisher = "Canonical"
#    offer     = "UbuntuServer"
#    sku       = "16.04-LTS"
#    version   = "latest"
#  }

#  storage_profile_os_disk {
#    name              = ""
#    caching           = "ReadWrite"
#    create_option     = "FromImage"
#    managed_disk_type = "Standard_LRS"
#  }

#  storage_profile_data_disk {
#    lun          = 0
#    caching        = "ReadWrite"
#    create_option  = "Empty"
#    disk_size_gb   = 10
#  }

#  os_profile {
#    computer_name_prefix = "vmlab"
#    admin_username       = var.admin_user
#    admin_password       = var.admin_password
#    custom_data          = file("web.conf")
#  }

#  os_profile_linux_config {
#    disable_password_authentication = false
#  }

#  network_profile {
#    name    = "terraformnetworkprofile"
#    primary = true

#    ip_configuration {
#      name                                   = "IPConfiguration"
#      subnet_id                              = azurerm_subnet.vmss.id
#      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
#      primary = true
#    }
#  }

#  tags = var.tags
# }