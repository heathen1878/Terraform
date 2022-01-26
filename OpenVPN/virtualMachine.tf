resource "azurerm_availability_set" "availabilitySet" {
  name = azurecaf_name.availabilitySet.result
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location = var.location
  managed = true
  platform_fault_domain_count = 2
  tags = var.tags
}

resource "azurerm_network_interface" "networkAdapter" {
  for_each = var.virtualMachines
  name = format("%s-%s", azurecaf_name.networkAdapter.result, substr(each.key, 2, -1))
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location = var.location
  ip_configuration {
    name = format("%s-%s%s", azurecaf_name.networkAdapter.result, substr(each.key, 2, -1), "-nic-ipconfig")
    subnet_id = azurerm_subnet.hubvNet_subnets[ each.value.subnet ].id
    private_ip_address_allocation = "static"
    private_ip_address = each.value.ipaddress
  }
  tags = merge(var.tags, {computerName = each.value.computerName})
}

resource "azurerm_linux_virtual_machine" "virtualMachine" {
  for_each = var.virtualMachines
  name = format("%s-%s", azurecaf_name.virtualMachineLinux.result, substr(each.key, 2, -1))
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location = var.location
  depends_on = [
    azurerm_network_interface.networkAdapter
  ]
  size = each.value.sku
  network_interface_ids = [
    azurerm_network_interface.networkAdapter[ each.key ].id
  ]
  availability_set_id = azurerm_availability_set.availabilitySet.id
  admin_username = each.value.username
  admin_password = random_string.linuxAdminPassword[ each.key ].result
  disable_password_authentication = false
    
  source_image_reference {
    publisher = "Debian"
    offer = "debian-10"
    sku = "10"
    version = "latest"
  }
  os_disk {
    name = format("%s-%s", azurecaf_name.managedOSDisk.result, substr(each.key, 2, -1))
    storage_account_type = "Standard_LRS"
    caching = "ReadWrite"
  }
  identity {
    type = "SystemAssigned"
  }
  tags = merge(var.tags, {computerName = each.value.computerName})
}
