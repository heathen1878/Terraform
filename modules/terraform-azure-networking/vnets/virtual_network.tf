resource "azurerm_virtual_network" "virtual_network" {
  for_each = var.virtual_networks

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  address_space       = each.value.address_space
  dns_servers         = each.value.dns_servers
  bgp_community       = each.value.bgp_community

  dynamic "ddos_protection_plan" {
    for_each = each.value.ddos_protection_plan.enable == true ? { "ddos" = "enabled" } : {}

    content {
      id     = ddos_protection_plan.id
      enable = ddos_protection_plan.enable
    }
  }

  edge_zone               = each.value.edge_zone
  flow_timeout_in_minutes = each.value.flow_timeout_in_minutes
  tags                    = each.value.tags

  lifecycle {
    ignore_changes = [ 
      dns_servers # DNS is managed by terraform-azure-networking/dns
     ]
  }
}
