# Azure Virtual Machine: Linux based bastionhost
# resource "azurerm_linux_virtual_machine" "bastion" {
#   name                  = "bastionhost"
#   location              = azurerm_resource_group.Dev_RG.location
#   resource_group_name   = azurerm_resource_group.Dev_RG.name
#   network_interface_ids = [azurerm_network_interface.bastionnic.id]
#   size                = "Standard_F2"
#   admin_username      = "azure-user"
  

# #   source_image_reference {
# #     publisher = "Canonical"
# #     offer     = "UbuntuServer"
# #     sku       = "16.04-LTS"
# #     version   = "latest"
# #   }
 
#  source_image_reference {
#     publisher = "OpenLogic"
#     offer     = "CentOS"
#     sku       = "7_9"
#     version   = "latest"
#   }

#   admin_ssh_key {
#     username   = "azure-user"
#     public_key = "${var.mykey}"
#   }

#   os_disk {
#     name = "bastion-osdisk"
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   /* connection {
#         host = self.public_ip_address
#         user = "adminuser"
#         type = "ssh"
#         private_key = "${file("~/Downloads/mykp.pem")}"
#         timeout = "4m"
#         agent = false
#     }

#   provisioner "remote-exec" {
#         inline = [
#       "sudo apt update",

#       "sudo apt install docker.io -y"
#         ]
#     } */
# }

### ########If you want to provision Linux based bastion host uncomment bastionpip and bastionnic resources in networkking.tf file AND comment thr below Azurr Web Bastion host related stuff ###################
###################### Azure Web Bastion host ####################
  resource "azurerm_subnet" "AzureBastionSubnet" {
    name                 = "AzureBastionSubnet"
    resource_group_name  = azurerm_resource_group.Dev_RG.name
    virtual_network_name = azurerm_virtual_network.Dev_VNet.name
    address_prefixes     = ["10.0.5.0/24"]
  }
  
  resource "azurerm_public_ip" "webbastionpip" {
    name                = "webbastionpip"
    location              = azurerm_resource_group.Dev_RG.location
    resource_group_name   = azurerm_resource_group.Dev_RG.name
    allocation_method   = "Static"
    sku                 = "Standard"
  }
  
  resource "azurerm_bastion_host" "webbastion" {
    name                = "webbastion"
    location              = azurerm_resource_group.Dev_RG.location
    resource_group_name   = azurerm_resource_group.Dev_RG.name
  
    ip_configuration {
      name                 = "configuration"
      subnet_id            = azurerm_subnet.AzureBastionSubnet.id
      public_ip_address_id = azurerm_public_ip.webbastionpip.id
    }
  }