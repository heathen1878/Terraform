
locals {

    virtual_network_subnets = {
        for subnet_key, subnet_value in data.terraform_remote_state.config.outputs.virtual_network_subnets.subnets : subnet_key => {
            address_space = cidrsubnet(azurerm_virtual_network.virtual_network.address_space[subnet_value.address_space_block], subnet_value.subnet_size, subnet_value.octet)
        }
    }

}

resource "azurerm_resource_group" "resource_group" {
    name = data.terraform_remote_state.config.outputs.virtual_network[format("%s_%s", var.namespace, var.environment)].resource_group_name
    location = var.location
    tags = merge(var.tags, {
        location = var.location
        environment = var.environment
        }
    )
}

resource "azurerm_virtual_network" "virtual_network" {
    name = data.terraform_remote_state.config.outputs.virtual_network[format("%s_%s", var.namespace, var.environment)].name
    resource_group_name = azurerm_resource_group.resource_group.name
    location = data.terraform_remote_state.config.outputs.virtual_network[format("%s_%s", var.namespace, var.environment)].location
    address_space = data.terraform_remote_state.config.outputs.virtual_network[format("%s_%s", var.namespace, var.environment)].address_space
    dns_servers = data.terraform_remote_state.config.outputs.virtual_network[format("%s_%s", var.namespace, var.environment)].dns_servers
    tags = data.terraform_remote_state.config.outputs.virtual_network[format("%s_%s", var.namespace, var.environment)].tags
}

resource "azurerm_subnet" "subnets" {
    for_each = local.virtual_network_subnets

    name = each.key
    resource_group_name = azurerm_resource_group.resource_group.name
    virtual_network_name = azurerm_virtual_network.virtual_network.name
    address_prefixes = [
        each.value.address_space
    ]
}

resource "azurerm_network_security_group" "nsg" {
  for_each = data.terraform_remote_state.config.outputs.subnets_with_nsgs_map
  name = each.value.nsgName
  location = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  tags = merge(var.tags, 
    {
        location = var.location
        environment = var.environment
    }
)
}

resource "azurerm_network_security_rule" "nsg_rules" {
  for_each = data.terraform_remote_state.config.outputs.nsg_rules_map
  
  # required
  name = each.key
  resource_group_name = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.nsg[ lower(format("%s_%s", each.value.nsg_name, lower(each.value.subnet))) ].name
  
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

  depends_on = [
    azurerm_subnet_network_security_group_association.nsg_to_subnet
  ]
}

# Maybe need to be a local variable to create the parameters for this resource
resource "azurerm_subnet_network_security_group_association" "nsg_to_subnet" {
  for_each = data.terraform_remote_state.config.outputs.subnets_with_nsgs_map
  subnet_id = azurerm_subnet.subnets[ each.value.subnet ].id
  network_security_group_id = azurerm_network_security_group.nsg[ each.key ].id
}
