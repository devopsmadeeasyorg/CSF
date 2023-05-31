# Network security group

resource "azurerm_network_security_group" "bastionnsg" {
  name                = "bastionnsg"
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

resource "azurerm_network_interface_security_group_association" "bastion_nic_nsg" {
  network_interface_id      = azurerm_network_interface.bastionnic.id
  network_security_group_id = azurerm_network_security_group.bastionnsg.id
}

resource "azurerm_network_interface_security_group_association" "webapp_nic_nsg" {
  network_interface_id      = azurerm_network_interface.webappnic.id
  network_security_group_id = azurerm_network_security_group.webappnsg.id
}










resource "azurerm_subnet_network_security_group_association" "private_subnet1_webappnsg" {
  subnet_id                 = azurerm_subnet.private_subnet1.id
  network_security_group_id = azurerm_network_security_group.webappnsg.id
}

resource "azurerm_subnet_network_security_group_association" "private_subnet2_webappnsg" {
  subnet_id                 = azurerm_subnet.private_subnet2.id
  network_security_group_id = azurerm_network_security_group.webappnsg.id
}


data "azurerm_client_config" "current" {}

# Key Vault
resource "azurerm_key_vault" "Dev-KV" {
  name                        = "Dev-KV-2023q2"
  resource_group_name = azurerm_resource_group.Dev_RG.name
  location            = azurerm_resource_group.Dev_RG.location
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}