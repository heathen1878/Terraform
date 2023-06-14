variable "virtual_network_gateway" {
  description = "A map of vnet gateway configuration"
  type = map(object(
    {
      name                = string
      resource_group_name = string
      location            = string
      active_active       = bool
      bgp_settings = object(
        {
          asn = optional(number)
          peering_addresses = object({
            apipa_addresses       = optional(list(string))
            ip_configuration_name = optional(string)
          })
          peer_weight = optional(number)
      })
      custom_route = optional(object(
        {
          address_prefixes = optional(list(string))
        }
      ))
      enable_bgp = bool
      generation = string
      ip_configuration = object(
        {
          name                          = string
          private_ip_address_allocation = string
          subnet_id                     = string
        }
      )
      private_ip_address_enabled = bool
      sku                        = string
      tags                       = map(any)
      type                       = string
      vpn_client_configuration = object(
        {
          aad_audience          = string
          aad_issuer            = string
          aad_tenant            = string
          address_space         = list(string)
          enabled               = bool
          radius_server_address = string
          radius_server_secret  = string
          vpn_auth_types        = list(string)
          vpn_client_protocols  = list(string)
        }
      )
      vpn_type                    = string
      pip_name                    = string
      pip_allocation_method       = string
      pip_ddos_protection_mode    = string
      pip_ddos_protection_plan_id = optional(string)
      pip_domain_name_label       = string
      pip_edge_zone               = optional(string)
      pip_idle_timeout_in_minutes = optional(number, 30)
      pip_ip_tags                 = map(any)
      pip_public_ip_prefix_id     = optional(string)
      pip_reverse_fqdn            = optional(string)
      pip_sku                     = string
      pip_sku_tier                = string
      pip_zones                   = list(string)
      tags                        = map(any)
    }
  ))
}