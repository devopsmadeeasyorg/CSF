resource "azurerm_managed_disk" "datadisk" {
  name = "${azurerm_linux_virtual_machine.webapp.name}-datadisk1"
  location            = azurerm_resource_group.Dev_RG.location
  resource_group_name = azurerm_resource_group.Dev_RG.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm_ddisk1" {
  managed_disk_id    = azurerm_managed_disk.datadisk.id
  virtual_machine_id = azurerm_linux_virtual_machine.webapp.id
  lun                = "10"
  caching            = "ReadWrite"
}