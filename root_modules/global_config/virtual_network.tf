locals {

  network_watchers = {
    management = {
      resource_group = "management"
    }
  }

  virtual_networks = merge(var.virtual_networks, {})

  # Uses the address_space attribute from virtual_networks_output to generate a subnet address prefix e.g. 
  # where the address space is 10.0.0.0/16 the subnet size of 10 with an octet of zero will result in 10.0.0.0/26.
  # The address space block attribute determines which block of address space is used e.g. a virtual network with more than one block would
  # be 0 for the first block, then 1 for the next block and so on. The virtual network is defined within tfvars - see variables.tf for the defaults.
  virtual_network_subnets = {
    default = {
      address_space_block = 0
      octet               = 0
      subnet_size         = 8
    }
    GatewaySubnet = {
      address_space_block = 0
      octet               = 1
      subnet_size         = 11
    }
    dnsinbound = {
      address_space_block = 0
      delegations = {
        dns_resolver = {
          name = "dnsResolvers"
          service_delegation = {
            name = "Microsoft.Network/dnsResolvers"
            actions = [
              "Microsoft.Network/virtualNetworks/subnets/action"
            ]
          }
        }
      }
      octet       = 2
      subnet_size = 8
    }

  }

  dns_resolvers = {
    management = {
      resource_group = "management"
    }
  }

  virtual_network_gateways = {
    management = {
      deploy_gateway        = true
      pip_allocation_method = "Static"
      pip_sku               = "Standard"
      resource_group        = "management"
    }
  }

  # ---------------------------------------------------------------------------------------------------------------------
  # LOCAL CALCULATED
  # ---------------------------------------------------------------------------------------------------------------------

  network_watcher_output = {
    for key, value in local.network_watchers : key => {
      name           = azurecaf_name.network_watcher[key].result
      resource_group = value.resource_group
      location       = local.location
      tags = merge(var.tags,
        {
          namespace = var.namespace
          location  = local.location
          usage     = key
        }
      )
    }
  }

  virtual_networks_output = {
    for key, value in local.virtual_networks : key => {
      name           = azurecaf_name.virtual_network[key].result
      resource_group = value.resource_group
      location       = local.location
      address_space  = value.address_space
      dns_servers    = value.dns_servers
      tags = merge(var.tags,
        {
          namespace = var.namespace
          location  = local.location
          usage     = key
        }
      )
    }
  }

  virtual_network_subnets_output = {
    for key, value in local.virtual_network_subnets : key => {
      name                                          = key
      resource_group                                = lookup(value, "resource_group", "management")
      virtual_network_key                           = lookup(value, "virtual_network_key", "management")
      address_space                                 = cidrsubnet(local.virtual_networks_output[lookup(value, "virtual_network_key", "management")].address_space[value.address_space_block], value.subnet_size, value.octet)
      delegations                                   = lookup(value, "delegations", {})
      private_endpoint_network_policies_enabled     = lookup(value, "private_endpoint_network_policies_enabled", true)
      private_link_service_network_policies_enabled = lookup(value, "private_link_service_network_policies_enabled", true)
      service_endpoints                             = lookup(value, "service_endpoints", null)
      service_endpoint_policy                       = lookup(value, "service_endpoint_policy", false)
    }
  }

  dns_resolver_output = {
    for key, value in local.dns_resolvers : key => {
      name                        = format("dnspr-%s", azurecaf_name.dns_resolver[key].result)
      resource_group              = lookup(value, "resource_group", "management")
      location                    = local.location
      virtual_network_key         = lookup(value, "virtual_network_key", "management")
      inbound_resolver_name       = format("in-%s", azurecaf_name.dns_resolver[key].result)
      inbound_resolver_subnet_key = lookup(value, "subnet_key", "dnsinbound")
      tags = merge(var.tags,
        {
          namespace = var.namespace
          location  = local.location
          usage     = key
        }
      )
    }
  }

  virtual_network_gateway_output = {
    for key, value in local.virtual_network_gateways : key => {
      name           = format("vgw-%s", azurecaf_name.virtual_network_gateway[key].result)
      resource_group = lookup(value, "resource_group", "management")
      location       = local.location
      ip_configuration = {
        name                          = lookup(value, "ip_configuration.name", "vnetGatewayConfig")
        private_ip_address_allocation = lookup(value, "ip_configuration.private_ip_address_allocation", "Dynamic")
        subnet_key                    = lookup(value, "ip_configuration.subnet_key", "GatewaySubnet")
      }
      sku            = lookup(value, "sku", "Basic")
      type           = lookup(value, "type", "Vpn")
      deploy_gateway = lookup(value, "deploy_gateway", false)
      active_active  = lookup(value, "active_active", false) # If true, requires HighPerformance SKU as a minimum.
      enable_bgp     = lookup(value, "enable_bgp", false)
      bgp_settings = {
        asn = lookup(value, "bgp_settings.asn", null)
        peering_addresses = {
          ip_configuration_name = lookup(value, "bgp_settings.peering_addresses.ip_configuration_name", "vnetGatewayConfig")
          apipa_addresses = lookup(value, "bgp_settings.peering_addresses.apipa_addresses", [
            "169.254.21.0"
          ])
        }
        peering_weight = lookup(value, "bgp_settings.peering_weight", 0)
      }
      custom_route = {
        address_prefixes = lookup(value, "custom_route.address_prefixes", [])
      }
      generation                 = lookup(value, "generation", "Generation1") #https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways#benchmark
      private_ip_address_enabled = lookup(value, "private_ip_address_enabled", false)
      public_ip_address_name     = format("pip-%s", azurecaf_name.virtual_network_gateway[key].result)
      vpn_client_configuration = {
        address_space = lookup(value, "vpn_client_configuration.address_space", [
          "172.16.0.0/24",
          "172.16.1.0/24"
        ])
        aad_tenant   = lookup(value, "vpn_client_configuration.aad_tenant", format("https://login.microsoftonline.com/%s/", var.tenant_id))
        aad_audience = lookup(value, "vpn_client_configuration.aad_audience", "41b23e61-6c1e-4545-b367-cd054e0ed4b4")
        aad_issuer   = lookup(value, "vpn_client_configuration.aad_issuer", format("https://sts.windows.net/%s/", var.tenant_id))
        root_certificate = {
        }
        radius_server_address = lookup(value, "vpn_client_configuration.radius_server_address", null)
        radius_server_secret  = lookup(value, "vpn_client_configuration.radius_server_secret", null)
        vpn_client_protocols = lookup(value, "vpn_client_configuration.vpn_client_protocols", [
          "OpenVPN"
        ])
        vpn_auth_types = lookup(value, "vpn_client_configuration.vpn_auth_types", [
          "AAD"
        ])
      }
      vpn_type                    = lookup(value, "vpn_type", "RouteBased")
      pip_allocation_method       = lookup(value, "pip_allocation_method", "Dynamic")
      pip_ddos_protection_mode    = lookup(value, "pip_ddos_protection_mode", "VirtualNetworkInherited")
      pip_ddos_protection_plan    = lookup(value, "pip_ddos_protection_plan", false)
      pip_domain_name_label       = lookup(value, "pip_domain_name_label", null)
      pip_edge_zone               = lookup(value, "pip_edge_zone", null) # TODO: work out what this actually does
      pip_idle_timeout_in_minutes = lookup(value, "pip_idle_timeout_in_minutes", 30)
      pip_ip_tags                 = lookup(value, "pip_ip_tags", {})
      pip_public_ip_prefix        = lookup(value, "pip_public_ip_prefix", false)
      pip_reverse_fqdn            = lookup(value, "pip_reverse_fqdn", null)
      pip_sku                     = lookup(value, "pip_sku", "Basic")
      pip_sku_tier                = lookup(value, "pip_sku_tier", "Regional")
      pip_zones                   = lookup(value, "pip_zones", [])
      tags = merge(var.tags,
        {
          namespace = var.namespace
          location  = local.location
          usage     = key
        }
      )
    }
  }

  subnets_with_nsgs_output = {
    for subnets_with_nsgs in flatten(
      [
        for key, values in var.nsg_rules : [
          {
            nsg_name = lower(azurecaf_name.network_security_group[key].result)
            subnet   = key
          }
        ]
    ]) : lower(format("%s_%s", subnets_with_nsgs.nsg_name, subnets_with_nsgs.subnet)) => subnets_with_nsgs
  }

  nsg_rules_output = {
    for nsg_rules in flatten(
      [
        for key, values in var.nsg_rules : [
          for rule_key, rule_value in values : {
            nsg_name                     = lower(azurecaf_name.network_security_group[key].result)
            subnet                       = key
            ruleId                       = rule_key
            name                         = rule_value.name
            priority                     = rule_value.priority
            protocol                     = rule_value.protocol
            direction                    = rule_value.direction
            access                       = rule_value.access
            description                  = rule_value.description == "" ? null : rule_value.description
            source_port_range            = rule_value.source_port_range == "" ? null : rule_value.source_port_range
            source_port_ranges           = length(rule_value.source_port_ranges) == 0 ? null : rule_value.source_port_ranges
            destination_port_range       = rule_value.destination_port_range == "" ? null : rule_value.destination_port_range
            destination_port_ranges      = length(rule_value.destination_port_ranges) == 0 ? null : rule_value.destination_port_ranges
            source_address_prefix        = rule_value.source_address_prefix == "" ? null : rule_value.source_address_prefix
            source_address_prefixes      = length(rule_value.source_address_prefixes) == 0 ? null : rule_value.source_address_prefixes
            destination_address_prefix   = rule_value.destination_address_prefix == "" ? null : rule_value.destination_address_prefix
            destination_address_prefixes = length(rule_value.destination_address_prefixes) == 0 ? null : rule_value.destination_address_prefixes
          }
        ]
    ]) : lower(format("%s_%s", nsg_rules.subnet, nsg_rules.ruleId)) => nsg_rules
  }
}
