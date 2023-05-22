resource "azurerm_public_ip" "virtual_network_gateway" {
  for_each = var.virtual_network_gateway

  name                    = each.value.pip_name
  location                = each.value.location
  resource_group_name     = each.value.resource_group_name
  allocation_method       = each.value.pip_allocation_method
  ddos_protection_mode    = each.value.pip_ddos_protection_mode
  ddos_protection_plan_id = each.value.pip_ddos_protection_plan_id
  domain_name_label       = each.value.pip_domain_name_label
  edge_zone               = each.value.pip_edge_zone
  idle_timeout_in_minutes = each.value.pip_idle_timeout_in_minutes
  ip_tags                 = each.value.pip_ip_tags
  public_ip_prefix_id     = each.value.pip_public_ip_prefix_id
  reverse_fqdn            = each.value.pip_reverse_fqdn
  sku                     = each.value.pip_sku
  sku_tier                = each.value.pip_sku_tier
  zones                   = each.value.pip_zones
  tags = merge(each.value.tags, {
    virtual_network_gateway = each.value.name
    }
  )
}

resource "azurerm_virtual_network_gateway" "virtual_network_gateway" {
  for_each = var.virtual_network_gateway

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  type                = each.value.type
  sku                 = each.value.sku

  ip_configuration {
    name                          = each.value.ip_configuration.name
    public_ip_address_id          = azurerm_public_ip.virtual_network_gateway[each.key].id
    private_ip_address_allocation = each.value.ip_configuration.private_ip_address_allocation
    subnet_id                     = each.value.ip_configuration.subnet_id
  }

  # Optional
  active_active = each.value.active_active

  enable_bgp = each.value.enable_bgp

  dynamic "bgp_settings" {
    for_each = each.value.enable_bgp == true ? { "bgp" = "enabled" } : {}

    content {
      asn = each.value.bgp_settings.asn
      peering_addresses {
        apipa_addresses       = each.value.peering_addresses.apipa_addresses
        ip_configuration_name = each.value.peering_addresses.ip_configuration_name
      }
      peer_weight = each.value.peer_weight
    }
  }

  dynamic "custom_route" {
    for_each = length(each.value.custom_route.address_prefixes) != 0 ? { "custom_routes" = "enabled" } : {}

    content {
      address_prefixes = each.value.custom_route.address_prefixes
    }

  }

  generation = each.value.generation

  private_ip_address_enabled = each.value.private_ip_address_enabled

  dynamic "vpn_client_configuration" {
    for_each = each.value.vpn_client_configuration.enabled == true ? { "client_vpn" = "enabled" } : {}

    content {
      address_space         = each.value.vpn_client_configuration.address_space
      aad_tenant            = each.value.vpn_client_configuration.aad_tenant
      aad_audience          = each.value.vpn_client_configuration.aad_audience
      aad_issuer            = each.value.vpn_client_configuration.aad_issuer
      radius_server_address = each.value.vpn_client_configuration.radius_server_address
      radius_server_secret  = each.value.vpn_client_configuration.radius_server_secret
      vpn_auth_types        = each.value.vpn_client_configuration.vpn_auth_types
      vpn_client_protocols  = each.value.vpn_client_configuration.vpn_client_protocols
    }
  }

  vpn_type = each.value.vpn_type
  tags     = each.value.tags

  timeouts {
    create = "90m"
    delete = "90m"
  }

}








      