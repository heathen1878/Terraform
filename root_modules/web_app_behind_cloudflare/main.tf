
module "service_plans" {
  source  = "heathen1878/app-service-plan/azurerm"
  version = "1.0.0"

  service_plans = local.service_plans
}

module "windows_web_apps" {
  source = "../../../terraform-azurerm-windows-web-app"
  #source  = "heathen1878/windows-web-app/azurerm"
  #version = "1.0.0"

  windows_web_apps = local.windows_web_apps
}

module "cloudflare_domain_verification_record" {
  source = "../../modules/terraform-cloudflare/dns_records"

  dns_record = local.web_app_verification_dns_record_cloudflare
}

module "pre_verify_cloudflare_cname_record" {
  source = "../../modules/terraform-cloudflare/dns_records"

  dns_record = local.pre_verify_web_app_cname_dns_record_cloudflare
}

module "azure_domain_verification_record" {
  source = "../../modules/terraform-azure-dns/records"

  record = local.web_app_verification_dns_record_azure
}

module "secure_custom_domain" {
  source = "../../../terraform-azurerm-secure-custom-domain"

  custom_domain = local.web_app_custom_domain
}

module "post_verify_cloudflare_cname_record" {
  source = "../../modules/terraform-cloudflare/dns_records"

  dns_record = local.post_verify_web_app_cname_dns_record_cloudflare
}

locals {


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



  web_app_verification_dns_record_cloudflare = {
    for dns_record in flatten([
      for key, value in local.windows_web_apps : [
        for dns_key, dns_value in value.dns_records : {
          zone_id = dns_value.zone_id
          name    = dns_key == "apex" ? format("asuid.%s", dns_value.zone) : format("asuid.%s.%s", dns_key, dns_value.zone)
          proxied = false
          value   = module.windows_web_apps.web_app[key].custom_domain_verification_id
          type    = "TXT"
          ttl     = dns_value.ttl
        } if dns_value.cloudflare_protected == true
      ]
    ]) : dns_record.name => dns_record
  }

  web_app_verification_dns_record_azure = {
    for dns_record in flatten([
      for key, value in local.windows_web_apps : [
        for dns_key, dns_value in value.dns_records : {
          zone_id = dns_value.zone_id
          name    = dns_key == "apex" ? format("asuid.%s", dns_value.zone) : format("asuid.%s.%s", dns_key, dns_value.zone)
          value   = module.windows_web_apps.web_app[key].custom_domain_verification_id
          type    = "TXT"
          ttl     = dns_value.ttl
        } if dns_value.azure_managed == true
      ]
    ]) : dns_record.name => dns_record
  }

  pre_verify_web_app_cname_dns_record_cloudflare = {
    for dns_record in flatten([
      for key, value in local.windows_web_apps : [
        for dns_key, dns_value in value.dns_records : {
          zone_id = dns_value.zone_id
          name    = dns_key == "apex" ? format("%s", dns_value.zone) : format("%s.%s", dns_key, dns_value.zone)
          proxied = false
          value   = module.windows_web_apps.web_app[key].default_hostname
          type    = dns_value.type
          ttl     = dns_value.ttl
        } if dns_value.cloudflare_protected == true
      ]
    ]) : dns_record.name => dns_record
  }

  web_app_cname_dns_record_azure = {
    for dns_record in flatten([
      for key, value in local.windows_web_apps : [
        for dns_key, dns_value in value.dns_records : {
          zone_id = dns_value.zone_id
          name    = dns_key == "apex" ? format("%s", dns_value.zone) : format("%s.%s", dns_key, dns_value.zone)
          value   = module.windows_web_apps.web_app[key].default_hostname
          type    = dns_value.type
          ttl     = dns_value.ttl
        } if dns_value.azure_managed == true
      ]
    ]) : dns_record.name => dns_record
  }

  web_app_custom_domain = {
    for dns_record in flatten([
      for key, value in local.windows_web_apps : [
        for dns_key, dns_value in value.dns_records : {
          hostname            = dns_key == "apex" ? format("%s", dns_value.zone) : format("%s.%s", dns_key, dns_value.zone)
          app_service_name    = module.windows_web_apps.web_app[key].name
          resource_group_name = module.windows_web_apps.web_app[key].resource_group_name
        } if dns_value.cloudflare_protected == true
      ]
    ]) : dns_record.hostname => dns_record
  }

  post_verify_web_app_cname_dns_record_cloudflare = {
    for dns_record in flatten([
      for key, value in local.windows_web_apps : [
        for dns_key, dns_value in value.dns_records : {
          zone_id = dns_value.zone_id
          name    = dns_key == "apex" ? format("%s", dns_value.zone) : format("%s.%s", dns_key, dns_value.zone)
          proxied = true
          value   = module.windows_web_apps.web_app[key].default_hostname
          type    = dns_value.type
          ttl     = dns_value.ttl
        } if dns_value.cloudflare_protected == true
      ]
    ]) : dns_record.name => dns_record
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