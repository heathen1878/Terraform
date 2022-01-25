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
  name = format("%s-%s", azurecaf_name.networkAdapter.result, each.value.computerName)
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location = var.location
  ip_configuration {
    name = format("%s-%s%s", azurecaf_name.networkAdapter.result, each.value.computerName, "-nic-ipconfig")
    subnet_id = azurerm_subnet.hubvNet_subnets[each.value.subnet].id
    private_ip_address_allocation = "static"
    private_ip_address = each.value.ipaddress
  }
  tags = merge(var.tags, {computerName = each.value.computerName})
}