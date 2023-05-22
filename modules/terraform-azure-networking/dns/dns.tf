resource "azurerm_private_dns_resolver" "resolver" {
  for_each = var.dns_resolver

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  virtual_network_id  = each.value.virtual_network_id
  tags                = each.value.tags
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "inbound_resolver" {
  for_each = var.dns_resolver

  name                    = each.value.inbound_resolver_name
  private_dns_resolver_id = azurerm_private_dns_resolver.resolver[each.key].id
  location                = azurerm_private_dns_resolver.resolver[each.key].location

  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = each.value.inbound_resolver_subnet_id
  }
  tags = merge(each.value.tags,
    {
      parent = azurerm_private_dns_resolver.resolver[each.key].name
    }
  )
}

resource "azurerm_virtual_network_dns_servers" "virtual_network_dns" {
  for_each = var.dns_resolver

  virtual_network_id = each.value.virtual_network_id
  dns_servers = [
    azurerm_private_dns_resolver_inbound_endpoint.inbound_resolver[each.key].ip_configurations[0].private_ip_address
  ]
}