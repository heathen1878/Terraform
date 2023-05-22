module "resource_groups" {
  source = "../../modules/terraform-azure-resource-group"

  resource_groups = data.terraform_remote_state.global_config.outputs.resource_groups
}

module "network_watcher" {
  source = "../../modules/terraform-azure-networking/network-watcher"

  network_watcher = local.network_watcher
}

module "virtual_network" {
  source = "../../modules/terraform-azure-networking/vnets"

  virtual_networks = local.virtual_network

  depends_on = [ 
    module.network_watcher
   ]
}

module "subnets" {
  source = "../../modules/terraform-azure-networking/subnets"

  subnets = local.subnets
}

module "dns_resolver" {
  source = "../../modules/terraform-azure-networking/dns"

  dns_resolver = local.dns_resolver
}

module "virtual_network_gateway" {
  source = "../../modules/terraform-azure-networking/gateway"

  virtual_network_gateway = local.virtual_network_gateways

  depends_on = [
    module.dns_resolver # Ensure the DNS resolver has set the custom DNS records before starting the Gateway deployment. 
  ]
}


locals {

  network_watcher = {
    for key, value in data.terraform_remote_state.global_config.outputs.network_watcher : key => {
      name                = value.name
      resource_group_name = module.resource_groups.resource_group[value.resource_group].name
      location            = value.location
      tags                = value.tags
    }
  }

  virtual_network = {
    for key, value in data.terraform_remote_state.global_config.outputs.virtual_network : key => {
      name                = value.name
      resource_group_name = module.resource_groups.resource_group[value.resource_group].name
      location            = value.location
      address_space       = value.address_space
      dns_servers         = value.dns_servers
      tags                = value.tags
    }
  }

  subnets = {
    for key, value in data.terraform_remote_state.global_config.outputs.virtual_network_subnets : key => {
      name                 = value.name
      resource_group_name  = module.resource_groups.resource_group[value.resource_group].name
      virtual_network_name = module.virtual_network.virtual_network[value.virtual_network_key].name
      address_prefixes = [
        value.address_space
      ]
      delegation                                    = value.delegations
      private_endpoint_network_policies_enabled     = value.private_endpoint_network_policies_enabled
      private_link_service_network_policies_enabled = value.private_link_service_network_policies_enabled
      service_endpoints                             = value.service_endpoints
      service_endpoint_policy_ids                   = value.service_endpoint_policy != false ? [] : null # TODO: work out how to dynamically get Ids if this is true.
    }
  }

  dns_resolver = {
    for key, value in data.terraform_remote_state.global_config.outputs.dns_resolver : key => {
      name                       = value.name
      resource_group_name        = module.resource_groups.resource_group[value.resource_group].name
      location                   = value.location
      virtual_network_id         = module.virtual_network.virtual_network[value.virtual_network_key].id
      inbound_resolver_name      = value.inbound_resolver_name
      inbound_resolver_subnet_id = module.subnets.subnet[value.inbound_resolver_subnet_key].id
      tags                       = value.tags
    }
  }

  virtual_network_gateways = {
    for key, value in data.terraform_remote_state.global_config.outputs.virtual_network_gateway : key => {
      name                = value.name
      resource_group_name = module.resource_groups.resource_group[value.resource_group].name
      location            = value.location
      active_active       = value.active_active
      bgp_settings = {
        asn = value.bgp_settings.asn
        peering_addresses = {
          apipa_addresses       = value.bgp_settings.peering_addresses.apipa_addresses
          ip_configuration_name = value.bgp_settings.peering_addresses.ip_configuration_name
        }
        peer_weight = value.bgp_settings.peer_weight
      }
      custom_route = {
        address_prefixes = value.custom_route.address_prefixes
      }
      enable_bgp = value.enable_bgp
      generation = value.generation
      ip_configuration = {
        name                          = value.ip_configuration.name
        private_ip_address_allocation = value.ip_configuration.private_ip_address_allocation
        subnet_id                     = module.subnets.subnet[value.ip_configuration.subnet_key].id
      }
      private_ip_address_enabled = value.private_ip_address_enabled
      sku                        = value.sku
      type                       = value.type
      vpn_client_configuration = {
        aad_audience          = value.vpn_client_configuration.aad_audience
        aad_issuer            = value.vpn_client_configuration.aad_issuer
        aad_tenant            = value.vpn_client_configuration.aad_tenant
        address_space         = value.vpn_client_configuration.address_space
        enabled               = value.vpn_client_configuration.enabled
        radius_server_address = value.vpn_client_configuration.radius_server_address
        radius_server_secret  = value.vpn_client_configuration.radius_server_secret
        vpn_auth_types        = value.vpn_client_configuration.vpn_auth_types
        vpn_client_protocols  = value.vpn_client_configuration.vpn_client_protocols
      }
      vpn_type                    = value.vpn_type
      pip_name                    = value.public_ip_address_name
      pip_allocation_method       = value.pip_allocation_method
      pip_ddos_protection_mode    = value.pip_ddos_protection_mode
      pip_ddos_protection_plan_id = value.pip_ddos_protection_plan == true ? "plan_id" : null # TODO: work out what this actually does
      pip_domain_name_label       = value.pip_domain_name_label
      pip_edge_zone               = value.pip_edge_zone # TODO: work out what this actually does
      pip_idle_timeout_in_minutes = value.pip_idle_timeout_in_minutes
      pip_ip_tags                 = value.pip_ip_tags
      pip_public_ip_prefix_id     = value.pip_public_ip_prefix == true ? "prefix_id" : null
      pip_reverse_fqdn            = value.pip_reverse_fqdn
      pip_sku                     = value.pip_sku
      pip_sku_tier                = value.pip_sku_tier
      pip_zones                   = value.pip_zones
      tags                        = value.tags
    } if value.deploy_gateway == true
  }

}