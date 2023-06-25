module "devops_projects" {
  source = "../../modules/terraform-azure-devops/projects"

  projects = local.devops_projects
}

module "resource_groups" {
  source  = "heathen1878/resource-groups/azurerm"
  version = "1.0.1"

  resource_groups = data.terraform_remote_state.global_config.outputs.resource_groups
}

module "networking" {
  source = "../../../terraform-azurerm-networking"

  network_watcher     = local.network_watcher
  virtual_networks    = local.virtual_network
  subnets             = local.subnets
  public_ip_addresses = local.public_ip_addresses
  nat_gateways        = local.nat_gateways
  route_tables        = local.route_tables
  routes              = local.routes
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

  devops_projects = {
    for key, value in data.terraform_remote_state.global_config.outputs.azdo_projects : key => {
      name               = value.name
      visibility         = value.visibility
      version_control    = value.version_control
      work_item_template = value.work_item_template
      description        = value.description
      features = {
        boards       = value.features[key].boards == "disabled" ? "disabled" : "enabled"
        repositories = value.features[key].repositories == "disabled" ? "disabled" : "enabled"
        pipelines    = value.features[key].pipelines == "disabled" ? "disabled" : "enabled"
        testplans    = value.features[key].testplans == "disabled" ? "disabled" : "enabled"
        artifacts    = value.features[key].artifacts == "disabled" ? "disabled" : "enabled"
      }
    }
  }

  network_watcher = {
    for key, value in data.terraform_remote_state.global_config.outputs.network_watcher : key => {
      name                = value.name
      resource_group_name = module.resource_groups.resource_group[value.resource_group].name
      location            = value.location
      tags                = value.tags
      use_existing        = value.use_existing
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
      name                = value.name
      resource_group_name = module.resource_groups.resource_group[value.resource_group].name
      virtual_network_key = value.virtual_network_key
      address_prefixes = [
        value.address_space
      ]
      delegation                                    = value.delegations
      private_endpoint_network_policies_enabled     = value.private_endpoint_network_policies_enabled
      private_link_service_network_policies_enabled = value.private_link_service_network_policies_enabled
      service_endpoints                             = value.service_endpoints
      service_endpoint_policy_ids                   = value.service_endpoint_policy != false ? [] : null # TODO: work out how to dynamically get Ids if this is true.
      enable_nat_gateway                            = value.enable_nat_gateway
      nat_gateway_key = value.nat_gateway_key
    }
  }

  nat_gateways = {
    for key, value in data.terraform_remote_state.global_config.outputs.nat_gateways : key => {
      name                    = value.name
      resource_group_name     = module.resource_groups.resource_group[value.resource_group].name
      location                = value.location
      idle_timeout_in_minutes = value.idle_timeout_in_minutes
      sku_name                = value.sku_name
      tags                    = value.tags
      zones                   = value.zones
    }
  }

  public_ip_addresses = {
    for key, value in data.terraform_remote_state.global_config.outputs.public_ip_addresses : key => {
      name                    = value.name
      resource_group_name     = module.resource_groups.resource_group[value.resource_group].name
      location                = value.location
      allocation_method       = value.allocation_method
      ddos_protection_mode    = value.ddos_protection_mode
      ddos_protection_plan_id = value.ddos_protection_plan == true ? "plan_id" : null # TODO: work out what this actually does
      domain_name_label       = value.domain_name_label
      edge_zone               = value.edge_zone # TODO: work out what this actually does
      idle_timeout_in_minutes = value.idle_timeout_in_minutes
      ip_version              = value.ip_version
      ip_tags                 = value.ip_tags
      public_ip_prefix_id     = value.public_ip_prefix == true ? "prefix_id" : null
      reverse_fqdn            = value.reverse_fqdn
      sku                     = value.sku
      sku_tier                = value.sku_tier
      tags                    = value.tags
      zones                   = value.zones
    }
  }

  route_tables = {
    for key, value in data.terraform_remote_state.global_config.outputs.route_tables.route_table : key => {
      name                          = value.name
      location                      = value.location
      resource_group_name           = module.resource_groups.resource_group[value.resource_group].name
      disable_bgp_route_propagation = value.disable_bgp_route_propagation
      tags                          = value.tags
    }
  }

  routes = {
    for key, value in data.terraform_remote_state.global_config.outputs.routes : key => {
      name                   = value.name
      resource_group_name    = module.resource_groups.resource_group[value.resource_group].name
      route_table_key        = value.route_table_key
      address_prefix         = value.address_prefix
      next_hop_type          = value.next_hop_type
      next_hop_in_ip_address = "10.10.0.10"
    }
  }

  dns_resolver = {
    for key, value in data.terraform_remote_state.global_config.outputs.dns_resolver : key => {
      name                       = value.name
      resource_group_name        = module.resource_groups.resource_group[value.resource_group].name
      location                   = value.location
      virtual_network_id         = module.networking.virtual_network[value.virtual_network_key].id
      inbound_resolver_name      = value.inbound_resolver_name
      inbound_resolver_subnet_id = module.networking.subnet[value.inbound_resolver_subnet_key].id
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
        subnet_id                     = module.networking.subnet[value.ip_configuration.subnet_key].id
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
      vpn_type = value.vpn_type
      tags     = value.tags
    } if value.deploy_gateway == true
  }

}