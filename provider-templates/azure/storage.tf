# Block storage
resource "azurerm_managed_disk" "datadisk" {
  name = "${azurerm_linux_virtual_machine.webapp_server_1.name}-datadisk1"
  location            = azurerm_resource_group.Dev_RG.location
  resource_group_name = azurerm_resource_group.Dev_RG.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm_ddisk1" {
  managed_disk_id    = azurerm_managed_disk.datadisk.id
  virtual_machine_id = azurerm_linux_virtual_machine.webapp_server_1.id
  lun                = "10"
  caching            = "ReadWrite"
}




# Blob storage
resource "azurerm_storage_account" "storageaccount" {
  name                = "storageaccount2023q2"
  location            = azurerm_resource_group.Dev_RG.location
  resource_group_name = azurerm_resource_group.Dev_RG.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Allow"
    ip_rules                   = ["0.0.0.0/0"]
    /* virtual_network_subnet_ids = [azurerm_subnet.example.id] */
  }

  tags = {
    environment = "develop"
  }
}

resource "azurerm_storage_container" "tfstatecontainer" {
  name                  = "tfstatecontainer"
  storage_account_name  = azurerm_storage_account.storageaccount.name
  container_access_type = "private"
}