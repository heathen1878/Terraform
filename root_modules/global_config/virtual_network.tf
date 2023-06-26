locals {

  network_watchers = {
    management = {
      resource_group = "global"
    }
  }

  virtual_networks = merge(var.virtual_networks, {})

  # Uses the address_space attribute from virtual_networks_output to generate a subnet address prefix e.g. 
  # where the address space is 10.0.0.0/16 the subnet size of 10 with an octet of zero will result in 10.0.0.0/26.
  # The address space block attribute determines which block of address space is used e.g. a virtual network with more than one block would
  # be 0 for the first block, then 1 for the next block and so on. The virtual network is defined within tfvars - see variables.tf for the defaults.
  virtual_network_subnets = {
    palo_alto_management = {
      address_space_block = 0
      octet               = 0
      subnet_size         = 8
    }
    palo_alto_public = {
      address_space_block = 1
      octet               = 0
      subnet_size         = 8
    }
    palo_alto_private = {
      address_space_block = 2
      octet               = 0
      subnet_size         = 8
    }
  }

  dns_resolvers = {}

  virtual_network_gateways = {}

  nat_gateways = {}

  public_ip_addresses = {}

  route_tables = {}

  udrs = {}

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
      use_existing = lookup(value, "use_existing", false)
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

  virtual_network_peers = {}

  virtual_network_subnets_output = {
    for key, value in local.virtual_network_subnets : key => {
      name                                          = key
      resource_group                                = lookup(value, "resource_group", "global")
      virtual_network_key                           = lookup(value, "virtual_network_key", "global")
      address_space                                 = cidrsubnet(local.virtual_networks_output[lookup(value, "virtual_network_key", "global")].address_space[value.address_space_block], value.subnet_size, value.octet)
      delegations                                   = lookup(value, "delegations", {})
      private_endpoint_network_policies_enabled     = lookup(value, "private_endpoint_network_policies_enabled", true)
      private_link_service_network_policies_enabled = lookup(value, "private_link_service_network_policies_enabled", true)
      service_endpoints                             = lookup(value, "service_endpoints", null)
      service_endpoint_policy                       = lookup(value, "service_endpoint_policy", false)
      enable_nat_gateway                            = lookup(value, "enable_nat_gateway", false)
      nat_gateway_key                               = lookup(value, "nat_gateway_key", "nat_gateway")
    }
  }

  dns_resolver_output = {
    for key, value in local.dns_resolvers : key => {
      name                        = format("dnspr-%s", azurecaf_name.dns_resolver[key].result)
      resource_group              = lookup(value, "resource_group", "global")
      location                    = local.location
      virtual_network_key         = lookup(value, "virtual_network_key", "global")
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

  nat_gateway_outputs = {
    for key, value in local.nat_gateways : key => {
      name                    = format("ng-%s", azurecaf_name.nat_gateway[key].result)
      resource_group          = value.resource_group
      location                = local.location
      idle_timeout_in_minutes = lookup(value, "idle_timeout_in_minutes", 4)
      sku_name                = lookup(value, "sku_name", "Standard")
      tags = merge(var.tags,
        {
          namespace = var.namespace
          location  = local.location
          usage     = key
        }
      )
      zones = lookup(value, "zones", [])
    }
  }

  virtual_network_gateway_output = {
    for key, value in local.virtual_network_gateways : key => {
      name           = format("vgw-%s", azurecaf_name.virtual_network_gateway[key].result)
      resource_group = lookup(value, "resource_group", "global")
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
        peer_weight = lookup(value, "bgp_settings.peering_weight", 0)
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
        enabled      = lookup(value, "vpn_client_configuration.enabled", false)
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
      vpn_type = lookup(value, "vpn_type", "RouteBased")
      tags = merge(var.tags,
        {
          namespace = var.namespace
          location  = local.location
          usage     = key
        }
      )
    }
  }

  public_ip_address_outputs = {
    for key, value in local.public_ip_addresses : key => {
      name                    = azurecaf_name.public_ip_address[key].result
      resource_group          = value.resource_group
      location                = local.location
      sku                     = lookup(value, "sku", "Basic")
      sku_tier                = lookup(value, "sku_tier", "Regional")
      allocation_method       = lookup(value, "allocation_method", "Dynamic")
      ip_version              = lookup(value, "ip_version", "IPv4")
      ip_tags                 = lookup(value, "ip_tags", {})
      idle_timeout_in_minutes = lookup(value, "idle_timeout_in_minutes", 4)
      domain_name_label       = lookup(value, "domain_name_label", null)
      ddos_protection_mode    = lookup(value, "ddos_protection_mode", "VirtualNetworkInherited")
      ddos_protection_plan    = lookup(value, "ddos_protection_plan", false)
      ddos_protection_plan_id = lookup(value, "ddos_protection_plan_id", null)
      edge_zone               = lookup(value, "edge_zone", null)
      reverse_fqdn            = lookup(value, "reverse_fqdn", null)
      public_ip_prefix        = lookup(value, "public_ip_prefix", false)
      public_ip_prefix_key    = lookup(value, "public_ip_prefix_key", null)
      tags = merge(var.tags,
        {
          namespace = var.namespace
          location  = local.location
        }
      )
      zones = lookup(value, "zones", [])
    }
  }

  route_table_outputs = {
    for key, value in local.route_tables : key => {
      name                          = format("rt-%s", azurecaf_name.route_table[key].result)
      location                      = local.location
      resource_group                = value.resource_group
      disable_bgp_route_propagation = lookup(value, "disable_bgp_route_propagation", false)
      tags = merge(var.tags,
        {
          namespace = var.namespace
          location  = local.location
          usage     = key
        }
      )
    }
  }

  route_table_associations = {
    for subnet in flatten([
      for key, value in local.route_tables : [
        for subnet_value in value.associated_subnets : {
          subnet_key      = subnet_value
          route_table_key = key
        }
      ] if length(value.associated_subnets) != 0
    ]) : format("%s_%s", subnet.subnet_key, subnet.route_table_key) => subnet
  }

  udr_outputs = {
    for udr in flatten([
      for key, value in local.udrs : [
        for association in value.route_table_association : {
          name                  = format("udr-%s", key)
          resource_group        = lookup(value, "resource_group", "global")
          route_table_key       = association
          address_prefix        = value.address_prefix
          next_hop_type         = value.next_hop_type
          virtual_appliance_key = value.next_hop_type == "VirtualAppliance" ? value.virtual_appliance_key : null
          route_table_key       = association
          udr                   = key
        }
      ] if length(value.route_table_association) != 0
    ]) : format("%s_%s", udr.udr, udr.route_table_key) => udr
  }

  nsgs = {
    for key, value in var.nsg_rules : key => {
      name           = lower(azurecaf_name.network_security_group[key].result)
      location       = local.location
      resource_group = value.resource_group
      tags = merge(var.tags,
        {
          namespace = var.namespace
          location  = local.location
          usage     = key
        }
      )
    }
  }

  nsg_subnet_association_outputs = {
    for subnets_with_nsgs in flatten([
      for key, values in var.nsg_rules : [
        {
          nsg_name = lower(azurecaf_name.network_security_group[key].result)
          key      = key
        }
      ]
    ]) : lower(format("%s_%s", subnets_with_nsgs.nsg_name, subnets_with_nsgs.key)) => subnets_with_nsgs
  }

  nsg_rule_outputs = {
    for nsg_rules in flatten([
      for key, value in var.nsg_rules : [
        for rule_key, rule_value in value.rules : {
          key                          = key
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
    ]) : lower(format("%s_%s", nsg_rules.key, nsg_rules.ruleId)) => nsg_rules
  }
}
