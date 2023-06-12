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