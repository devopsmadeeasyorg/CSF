# Resource Group
resource "azurerm_resource_group" "Dev_RG" {
  name     = "Dev-RG"
  location = "${var.mylocation}"
}

