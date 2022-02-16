
resource "azurerm_network_security_group" "nsg" {
  for_each = local.subnetsWithNsgs_map
  name = each.value.nsgName
  location = var.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  tags = var.tags
}

resource "azurerm_network_security_rule" "nsgRules" {
  for_each = local.nsgRules_map
  
  # required
  name = each.key
  resource_group_name = azurerm_resource_group.resourceGroup.name
  network_security_group_name = azurerm_network_security_group.nsg[ lower(format("%s-%s_%s", azurecaf_name.networkSecurityGroup.result, each.value.subnet , each.value.subnet)) ].name
  
  priority = each.value.priority
  protocol = each.value.protocol
  direction = each.value.direction
  access = each.value.access

  # optional
  description = each.value.description
  source_port_range = each.value.source_port_range
  source_port_ranges = each.value.source_port_ranges
  destination_port_range = each.value.destination_port_range
  destination_port_ranges = each.value.destination_port_ranges
  source_address_prefix = each.value.source_address_prefix
  source_address_prefixes = each.value.source_address_prefixes
  destination_address_prefix = each.value.destination_address_prefix
  destination_address_prefixes = each.value.destination_address_prefixes
}

# Maybe need to be a local variable to create the parameters for this resource
resource "azurerm_subnet_network_security_group_association" "nsgToSubnet" {
  for_each = local.subnetsWithNsgs_map
  subnet_id = azurerm_subnet.hubvNet_subnets[ each.value.subnet ].id
  network_security_group_id = azurerm_network_security_group.nsg[ each.key ].id
}
