module "resource_groups" {
  source = "../../modules/terraform-azure-resource-group"

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

module "dns_records" {
  source = "../../modules/terraform-ionos-dns"

  dns_record = local.cloudflare_nameservers
}

module "service_plans" {
  source = "../../modules/terraform-azure-service-plan"

  service_plans = local.service_plans
}

module "windows_web_apps" {
  source = "../../modules/terraform-azure-web-app/windows"

  windows_web_apps = local.windows_web_apps
}

module "web_app_cloudflare_records" {
  source = "../../modules/terraform-cloudflare/dns_records"

  dns_record = local.cloudflare_cname_record
}

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

  service_plans = {
    for key, value in data.terraform_remote_state.config.outputs.service_plans : key => {
      name                         = value.name
      resource_group_name          = module.resource_groups.resource_group[value.resource_group].name
      location                     = value.location
      os_type                      = value.os_type
      sku_name                     = value.sku_name
      maximum_elastic_worker_count = value.maximum_elastic_worker_count
      per_site_scaling_enabled     = value.per_site_scaling_enabled
      tags                         = value.tags
      worker_count                 = value.worker_count
      zone_balancing_enabled       = value.zone_balancing_enabled
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
      enabled                            = value.enabled
      https_only                         = value.https_only
      identity                           = value.identity
      ip_restriction                     = value.cloudflare_protected ? module.cloudflare_ip_addresses.ip_addresses.ipv4 : []
      key_vault_reference_identity_id    = value.key_vault_reference_identity_id
      logs                               = value.logs
      sticky_settings                    = value.sticky_settings
      storage_account                    = value.storage_account
      tags                               = value.tags
      virtual_network_subnet_id          = value.virtual_network_subnet_id
      zip_deploy_file                    = value.zip_deploy_file
    }
  }

  cloudflare_cname_record = {
    for key, value in data.terraform_remote_state.config.outputs.cloudflare.dns_records : key => {
      zone_id = module.cloudflare_zone.zone[value.zone].id
      name    = key == "apex" ? replace(value.zone, "_", ".") : key
      proxied = value.proxied
      value   = module.windows_web_apps.web_app[value.content].default_hostname
      type    = value.type
      ttl     = value.ttl
    }
  }

}