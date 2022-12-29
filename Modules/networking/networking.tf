
locals {

  location = replace(lower(var.location), " ", "")

  virtual_network_subnets = {
    for subnet_key, subnet_value in data.terraform_remote_state.config.outputs.virtual_network_subnets.subnets : subnet_key => {
      address_space = cidrsubnet(azurerm_virtual_network.virtual_network[format("%s_%s_%s", var.namespace, var.environment, local.location)].address_space[subnet_value.address_space_block], subnet_value.subnet_size, subnet_value.octet)
      delegations   = subnet_value.delegations
    }
  }

}

resource "azurerm_network_watcher" "network_watcher" {
  for_each = data.terraform_remote_state.config.outputs.network_watcher

  name                = each.value.name
  location            = data.terraform_remote_state.resource_group.outputs.resource_group[each.value.resource_group_name].location
  resource_group_name = data.terraform_remote_state.resource_group.outputs.resource_group[each.value.resource_group_name].name
  tags = merge(var.tags,
    {
      location = data.terraform_remote_state.resource_group.outputs.resource_group[each.value.resource_group_name].location
    }
  )
}

resource "azurerm_virtual_network" "virtual_network" {
  for_each = data.terraform_remote_state.config.outputs.virtual_network

  name                = each.value.name
  resource_group_name = data.terraform_remote_state.resource_group.outputs.resource_group[each.value.resource_group_name].name
  location            = data.terraform_remote_state.resource_group.outputs.resource_group[each.value.resource_group_name].location
  address_space       = each.value.address_space
  dns_servers         = each.value.dns_servers
  tags                = each.value.tags
}

resource "azurerm_subnet" "subnets" {
  for_each = local.virtual_network_subnets

  name                 = each.key
  resource_group_name  = azurerm_virtual_network.virtual_network[format("%s_%s_%s", var.namespace, var.environment, local.location)].resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network[format("%s_%s_%s", var.namespace, var.environment, local.location)].name
  address_prefixes = [
    each.value.address_space
  ]

  dynamic "delegation" {
    for_each = {
      for delegation_key, delegation_value in each.value.delegations : delegation_key => delegation_value
    }

    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }

}

resource "azurerm_network_security_group" "nsg" {
  for_each = data.terraform_remote_state.config.outputs.subnets_with_nsgs_map

  name                = each.value.nsg_name
  location            = azurerm_virtual_network.virtual_network[format("%s_%s_%s", var.namespace, var.environment, local.location)].location
  resource_group_name = azurerm_virtual_network.virtual_network[format("%s_%s_%s", var.namespace, var.environment, local.location)].resource_group_name
  tags = merge(var.tags,
    {
      location    = var.location
      environment = var.environment
    }
  )
}

resource "azurerm_network_security_rule" "nsg_rules" {
  for_each = data.terraform_remote_state.config.outputs.nsg_rules_map

  # required
  name                        = each.key
  resource_group_name         = azurerm_virtual_network.virtual_network[format("%s_%s_%s", var.namespace, var.environment, local.location)].resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg[lower(format("%s_%s", each.value.nsg_name, lower(each.value.subnet)))].name

  priority  = each.value.priority
  protocol  = each.value.protocol
  direction = each.value.direction
  access    = each.value.access

  # optional
  description                  = each.value.description
  source_port_range            = each.value.source_port_range
  source_port_ranges           = each.value.source_port_ranges
  destination_port_range       = each.value.destination_port_range
  destination_port_ranges      = each.value.destination_port_ranges
  source_address_prefix        = each.value.source_address_prefix
  source_address_prefixes      = each.value.source_address_prefixes
  destination_address_prefix   = each.value.destination_address_prefix
  destination_address_prefixes = each.value.destination_address_prefixes

  depends_on = [
    azurerm_subnet_network_security_group_association.nsg_to_subnet
  ]
}

# Maybe need to be a local variable to create the parameters for this resource
resource "azurerm_subnet_network_security_group_association" "nsg_to_subnet" {
  for_each = data.terraform_remote_state.config.outputs.subnets_with_nsgs_map

  subnet_id                 = azurerm_subnet.subnets[each.value.subnet].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}
