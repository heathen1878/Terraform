module "resource_groups" {
  source  = "heathen1878/resource-groups/azurerm"
  version = "1.0.1"

  resource_groups = data.terraform_remote_state.config.outputs.resource_groups
}

module "cloudflare_account" {
  source = "../../modules/terraform-cloudflare/accounts"

  account_names = local.cloudflare_accounts
}

module "cloudflare_zone" {
  source = "../../modules/terraform-cloudflare/zones"

  zones = local.cloudflare_zones
}

module "cloudflare_ip_addresses" {
  source = "../../modules/terraform-cloudflare/ip_addresses"
}

module "cloudflare_public_dns_records" {
  source  = "heathen1878/dns/ionos"
  version = "1.0.0"

  dns_record = local.cloudflare_nameservers
}

module "networking" {
  source  = "heathen1878/networking/azurerm"
  version = "1.0.0"

  network_watcher       = local.network_watcher
  virtual_networks      = local.virtual_network
  virtual_network_peers = local.virtual_network_peers
  subnets               = local.subnets
  public_ip_addresses   = local.public_ip_addresses
  nat_gateways          = local.nat_gateways
  route_tables          = local.route_tables
  routes                = local.routes
  nsgs                  = local.nsgs
  nsg_rules             = data.terraform_remote_state.config.outputs.networking.nsg_rules
  nsg_association       = data.terraform_remote_state.config.outputs.networking.nsg_subnet_association
}

module "dns" {
  source  = "heathen1878/dns/azurerm"
  version = "1.0.0"

  private_dns_zones = local.private_dns_zones
  public_dns_zones  = local.public_dns_zones
}

module "azure_public_dns_records" {
  source  = "heathen1878/dns/ionos"
  version = "1.0.0"

  dns_record = local.azure_nameservers
}

module "service_plans" {
  source  = "heathen1878/app-service-plan/azurerm"
  version = "1.0.0"

  service_plans = local.service_plans
}

module "windows_web_apps" {
  source  = "heathen1878/windows-web-app/azurerm"
  version = "1.0.0"

  windows_web_apps = local.windows_web_apps
}

#module "cloudflare_domain_verification_record" {
#  source = "../../modules/terraform-cloudflare/dns_records"
#
#  dns_record = local.cloudflare_txt_domain_verification_record
#}

# TODO: Create a custom domain name host binding
# TODO: Add CNAMEs with for DNS resolution only
# TODO: Create a module which creates a managed certificate
# TODO: Create a cert binding using the host and cert above
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_managed_certificate
# TODO: Set Cloudflare SSL to strict.
# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zone_settings_override#ssl
# TODO: Set Cloudflare to redirect HTTP to HTTPS
# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zone_settings_override#always_use_https

# Adds CNAMEs with proxy set - probably needs to use the existing resource 
#module "web_app_cloudflare_records" {
#  source = "../../modules/terraform-cloudflare/dns_records"
#
#  dns_record = local.cloudflare_cname_record
#}

locals {

  cloudflare_accounts = {
    for key, value in data.terraform_remote_state.config.outputs.cloudflare.zones : key => {
      account_name = value.account_name
    }
  }

  cloudflare_zones = {
    for key, value in data.terraform_remote_state.config.outputs.cloudflare.zones : key => {
      account_id = module.cloudflare_account.account[key].accounts[0].id
      zone       = value.zone
      jump_start = value.jump_start
      paused     = value.paused
      plan       = value.plan
      type       = value.type
    }
  }

  cloudflare_nameservers = {
    for nameserver in flatten([
      for key, value in module.cloudflare_zone.zone : [
        for ns_value in value.name_servers : {
          zone_name = replace(key, "_", ".")
          name      = replace(key, "_", ".")
          type      = "NS"
          content   = ns_value
          ttl       = 3600
        }
      ]
    ]) : format("%s_%s", nameserver.zone_name, nameserver.content) => nameserver
  }

  network_watcher = {
    for key, value in data.terraform_remote_state.config.outputs.networking.network_watcher : key => {
      name                = value.name
      resource_group_name = module.resource_groups.resource_group[value.resource_group].name
      location            = value.location
      tags                = value.tags
      use_existing        = value.use_existing
    }
  }

  virtual_network = {
    for key, value in data.terraform_remote_state.config.outputs.networking.virtual_networks : key => {
      name                = value.name
      resource_group_name = module.resource_groups.resource_group[value.resource_group].name
      location            = value.location
      address_space       = value.address_space
      dns_servers         = value.dns_servers
      tags                = value.tags
    }
  }

  virtual_network_peers = {
    for key, value in data.terraform_remote_state.config.outputs.networking.virtual_network_peers : key => {
      peer_1_id   = value.peer_1_id
      peer_1_rg   = value.peer_1_rg
      peer_1_name = value.peer_1_name
      peer_2_id   = value.peer_2_id
    }
  }

  subnets = {
    for key, value in data.terraform_remote_state.config.outputs.networking.subnets : key => {
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
      nat_gateway_key                               = value.nat_gateway_key
    }
  }

  nat_gateways = {
    for key, value in data.terraform_remote_state.config.outputs.networking.nat_gateways : key => {
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
    for key, value in data.terraform_remote_state.config.outputs.networking.public_ip_addresses : key => {
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
    for key, value in data.terraform_remote_state.config.outputs.networking.route_tables : key => {
      name                          = value.name
      location                      = value.location
      resource_group_name           = module.resource_groups.resource_group[value.resource_group].name
      disable_bgp_route_propagation = value.disable_bgp_route_propagation
      tags                          = value.tags
    }
  }

  routes = {
    for key, value in data.terraform_remote_state.config.outputs.networking.routes : key => {
      name                   = value.name
      resource_group_name    = module.resource_groups.resource_group[value.resource_group].name
      route_table_key        = value.route_table_key
      address_prefix         = value.address_prefix
      next_hop_type          = value.next_hop_type
      next_hop_in_ip_address = "10.10.0.10" # TODO: this needs to be a lookup if the next hop type is virtual appliance.
    }
  }

  nsgs = {
    for key, value in data.terraform_remote_state.config.outputs.networking.nsgs : key => {
      name                = value.name
      location            = value.location
      resource_group_name = module.resource_groups.resource_group[value.resource_group].name
      tags                = value.tags
    }
  }

  public_dns_zones = {
    for key, value in data.terraform_remote_state.config.outputs.dns.zones : key => {
      name                = value.name
      resource_group_name = module.resource_groups.resource_group[value.resource_group].name
      tags                = value.tags
    }
  }

  private_dns_zones = {
    for key, value in data.terraform_remote_state.config.outputs.dns.private_dns_zones : key => {
      name                 = value.name
      resource_group_name  = module.resource_groups.resource_group[value.resource_group].name
      tags                 = value.tags
      virtual_network_name = module.networking.virtual_network["environment"].name
      virtual_network_id   = module.networking.virtual_network["environment"].id
    }
  }

  azure_nameservers = {
    for nameserver in flatten([
      for key, value in module.dns.public_dns_zones : [
        for ns_value in value.name_servers : {
          zone_name = replace(key, "_", ".")
          name      = replace(key, "_", ".")
          type      = "NS"
          content   = ns_value
          ttl       = 3600
        }
      ]
    ]) : format("%s_%s", nameserver.zone_name, nameserver.content) => nameserver
  }

  dns_resolver = {
    for key, value in data.terraform_remote_state.config.outputs.networking.dns_resolvers : key => {
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
    for key, value in data.terraform_remote_state.config.outputs.networking.virtual_network_gateways : key => {
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

  key_vaults = {
    for key, value in data.terraform_remote_state.config.outputs.key_vault : key => {
      name                      = value.name
      resource_group_name       = module.resource_groups.resource_group[value.resource_group].name
      location                  = module.resource_groups.resource_group[value.resource_group].location
      tenant_id                 = value.tenant_id
      sku_name                  = value.sku_name
      enable_rbac_authorization = value.enable_rbac_authorization
      network_acls              = value.network_acls
      tags                      = value.tags
    }
  }

  service_plans = {
    for key, value in data.terraform_remote_state.config.outputs.service_plans : key => {
      name                         = value.name
      resource_group_name          = module.resource_groups.resource_group[value.resource_group].name
      location                     = module.resource_groups.resource_group[value.resource_group].location
      os_type                      = value.os_type
      sku_name                     = value.sku_name
      maximum_elastic_worker_count = value.maximum_elastic_worker_count
      per_site_scaling_enabled     = value.per_site_scaling_enabled
      tags = merge(value.tags, {
        workload = key
      })
      worker_count           = value.worker_count
      zone_balancing_enabled = value.zone_balancing_enabled
    }
  }

  windows_web_apps = {
    for key, value in data.terraform_remote_state.config.outputs.web_apps.windows : key => {
      name                               = value.name
      resource_group_name                = module.resource_groups.resource_group[value.resource_group].name
      location                           = value.location
      service_plan_id                    = module.service_plans.service_plan[value.service_plan].id
      site_config                        = value.site_config
      app_settings                       = value.app_settings
      auth_settings                      = value.auth_settings
      auth_settings_v2                   = value.auth_settings_v2
      backup                             = value.backup
      client_affinity_enabled            = value.client_affinity_enabled
      client_certificate_enabled         = value.client_certificate_enabled
      client_certificate_exclusion_paths = value.client_certificate_exclusion_paths
      client_certificate_mode            = value.client_certificate_mode
      connection_string                  = value.connection_string
      deploy_slot                        = value.deploy_slot
      enabled                            = value.enabled
      https_only                         = value.https_only
      identity                           = value.identity
      ip_restriction                     = value.cloudflare_protected ? module.cloudflare_ip_addresses.ip_addresses.ipv4 : []
      key_vault_reference_identity_id    = value.key_vault_reference_identity_id
      logs                               = value.logs
      sticky_settings                    = value.sticky_settings
      storage_account                    = value.storage_account
      tags = merge(value.tags, {
        parent = module.service_plans.service_plan[value.service_plan].name
        name   = key
      })
      virtual_network_subnet_id = value.virtual_network_subnet_id
      zip_deploy_file           = value.zip_deploy_file
    }
  }

  #custom_domain_certificate = {
  #  for key, value in data.terraform_remote_state.config.outputs.dns.web_app_association : key => {
  #    name                = key
  #    resource_group_name = module.windows_web_apps.web_app[value.web_app].resource_group_name
  #    location            = module.windows_web_apps.web_app[value.web_app].location
  #    app_service_plan_id = module.windows_web_apps.web_app[value.web_app].id
  #    key_vault_secret_id = module.key_vault_secrets.secret[value.zone].id
  #  }
  #}

  #cloudflare_txt_domain_verification_record = {
  #  for key, value in data.terraform_remote_state.config.outputs.cloudflare.dns_records : key => {
  #    zone_id = module.cloudflare_zone.zone[value.zone].id
  #    name    = key == "apex" ? format("asuid.%s", replace(value.zone, "_", ".")) : format("asuid.%s.%s", key, replace(value.zone, "_", "."))
  #    proxied = false
  #    value   = module.windows_web_apps.web_app[value.associated_web_app].custom_domain_verification_id
  #    type    = "TXT"
  #    ttl     = value.ttl
  #  }
  #}

  #web_app_custom_domain = {
  #  for key, value in data.terraform_remote_state.config.outputs.cloudflare.dns_records : key => {
  #    hostname            = key == "apex" ? replace(value.zone, "_", ".") : format("%s.%s", key, replace(value.zone, "_", "."))
  #    app_service_name    = module.windows_web_apps.web_app[value.associated_web_app].name
  #    resource_group_name = module.windows_web_apps.web_app[value.associated_web_app].resource_group_name
  #    ssl_state           = null
  #    thumbprint          = null
  #  }
  #}

  #cloudflare_cname_record = {
  #  for key, value in data.terraform_remote_state.config.outputs.cloudflare.dns_records : key => {
  #    zone_id = module.cloudflare_zone.zone[value.zone].id
  #    name    = key == "apex" ? replace(value.zone, "_", ".") : key
  #    proxied = value.proxied
  #    value   = module.windows_web_apps.web_app[value.associated_web_app].default_hostname
  #    type    = value.type
  #    ttl     = value.ttl
  #  }
  #}

}