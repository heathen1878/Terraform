resource "azurerm_network_security_group" "nsg" {
  name = azurecaf_name.networkSecurityGroup.result
  location = var.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  tags = var.tags
}

/*
resource "azurerm_network_security_rule" "nsgRules" {
    for_each = var.nsgRules
    name = each.value.name
    priority = each.value.priority
    direction = each.value.direction
    access = each.value.access
    protocol = each.value.protocol
    source_port_range = each.value.source_port_range
    destination_port_range = each.value.destination_port_range
    source_address_prefix = each.value.source_address_prefix
    destination_address_prefix = each.value.destination_address_prefix
    resource_group_name = azurerm_resource_group.resourceGroup.name
    network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_subnet_network_security_group_association" "nsgToSubnet" {
    subnet_id = azurerm_subnet.hubvNet_subnets["OpenVpn"].id
    network_security_group_id = azurerm_network_security_group.nsg.id
}
*/