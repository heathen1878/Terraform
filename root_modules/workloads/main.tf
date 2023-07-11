module "service_plans" {
  source  = "heathen1878/app-service-plan/azurerm"
  version = "1.0.0"

  service_plans = local.service_plans
}

module "function_app_consumption_plans" {
  source  = "heathen1878/app-service-plan/azurerm"
  version = "1.0.0"

  service_plans = local.consumption_plans
}

module "function_app_premium_plans" {
  source  = "heathen1878/app-service-plan/azurerm"
  version = "1.0.0"

  service_plans = local.premium_plans
}

module "windows_web_apps" {
  source  = "heathen1878/windows-web-app/azurerm"
  version = "1.0.1"

  windows_web_apps = local.windows_web_apps
}

module "cloudflare_domain_verification_record" {
  source  = "heathen1878/dns-records/cloudflare"
  version = "1.0.0"

  dns_record = local.web_app_verification_dns_record_cloudflare
}

module "secure_custom_domain" {
  source  = "heathen1878/secure-custom-domain/azurerm"
  version = "1.0.0"

  custom_domain           = local.web_app_custom_domain
  app_service_certificate = local.app_service_certificate

  depends_on = [
    module.cloudflare_domain_verification_record
  ]
}

module "cloudflare_cname_record" {
  source  = "heathen1878/dns-records/cloudflare"
  version = "1.0.0"

  dns_record = local.web_app_cname_dns_record_cloudflare

  depends_on = [
    module.cloudflare_domain_verification_record,
    module.secure_custom_domain
  ]
}

locals {

  service_plans = {
    for key, value in data.terraform_remote_state.config.outputs.service_plans : key => {
      name                         = value.name
      resource_group_name          = data.terraform_remote_state.infrastructure.outputs.resource_groups[value.resource_group].name
      location                     = value.location
      os_type                      = value.os_type
      sku_name                     = value.sku_name
      maximum_elastic_worker_count = value.maximum_elastic_worker_count
      per_site_scaling_enabled     = value.per_site_scaling_enabled
      tags = merge(value.tags,
        {
          workload = key
      })
      worker_count           = value.worker_count
      zone_balancing_enabled = value.zone_balancing_enabled
    }
  }

  consumption_plans = {
    for key, value in data.terraform_remote_state.config.outputs.function.consumption_plans : key => {
      name                         = value.name
      resource_group_name          = data.terraform_remote_state.infrastructure.outputs.resource_groups[value.resource_group].name
      location                     = value.location
      os_type                      = value.os_type
      sku_name                     = value.sku_name
      maximum_elastic_worker_count = value.maximum_elastic_worker_count
      per_site_scaling_enabled     = value.per_site_scaling_enabled
      tags = merge(value.tags,
        {
          workload = key
      })
      worker_count           = value.worker_count
      zone_balancing_enabled = value.zone_balancing_enabled
    }
  }

  premium_plans = {
    for key, value in data.terraform_remote_state.config.outputs.function.premium_plans : key => {
      name                         = value.name
      resource_group_name          = data.terraform_remote_state.infrastructure.outputs.resource_groups[value.resource_group].name
      location                     = value.location
      os_type                      = value.os_type
      sku_name                     = value.sku_name
      maximum_elastic_worker_count = value.maximum_elastic_worker_count
      per_site_scaling_enabled     = value.per_site_scaling_enabled
      tags = merge(value.tags,
        {
          workload = key
      })
      worker_count           = value.worker_count
      zone_balancing_enabled = value.zone_balancing_enabled
    }
  }

  windows_web_apps = {
    for key, value in data.terraform_remote_state.config.outputs.web_apps.windows : key => {
      name                               = value.name
      resource_group_name                = data.terraform_remote_state.infrastructure.outputs.resource_groups[value.resource_group].name
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
      cloudflare_protected               = value.cloudflare_protected
      connection_string                  = value.connection_string
      deploy_slot                        = value.deploy_slot
      dns_records                        = value.dns_records
      enabled                            = value.enabled
      enable_private_endpoint            = value.enable_private_endpoint
      https_only                         = value.https_only
      identity                           = value.identity
      key_vault_reference_identity_id    = value.key_vault_reference_identity_id
      logs                               = value.logs
      private_dns_zone_ids = [
        data.terraform_remote_state.infrastructure.outputs.dns.zones.private["azurewebsites"].id,
        data.terraform_remote_state.infrastructure.outputs.dns.zones.private["scm_azurewebsites"].id
      ]
      sticky_settings = value.sticky_settings
      storage_account = value.storage_account
      tags = merge(value.tags, {
        parent = module.service_plans.service_plan[value.service_plan].name
        name   = key
      })
      virtual_network_subnet_private_endpoint_id   = data.terraform_remote_state.infrastructure.outputs.subnets[value.virtual_network_subnet_private_endpoint_key].id
      virtual_network_subnet_integration_subnet_id = value.virtual_network_subnet_integration_subnet_key != null ? data.terraform_remote_state.infrastructure.outputs.subnets[value.virtual_network_subnet_integration_subnet_key].id : null
      zip_deploy_file                              = value.zip_deploy_file
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

  app_service_certificate = {
    for key, value in data.terraform_remote_state.config.outputs.certificate_name : key => {
      name                     = value.name
      resource_group_name      = data.terraform_remote_state.infrastructure.outputs.resource_groups[value.resource_group].name
      location                 = var.location
      key_vault_certificate_id = data.azurerm_key_vault_certificate.lets_encrypt_certificate[key].secret_id
    }
  }

  web_app_custom_domain = {
    for dns_record in flatten([
      for key, value in local.windows_web_apps : [
        for dns_key, dns_value in value.dns_records : {
          hostname            = dns_key == "apex" ? format("%s", dns_value.zone) : format("%s.%s", dns_key, dns_value.zone)
          app_service_name    = module.windows_web_apps.web_app[key].name
          location            = value.location
          resource_group_name = module.windows_web_apps.web_app[key].resource_group_name
          cert_key            = dns_value.key
        } if dns_value.cloudflare_protected == true
      ]
    ]) : dns_record.hostname => dns_record
  }

  web_app_cname_dns_record_cloudflare = {
    for dns_record in flatten([
      for key, value in local.windows_web_apps : [
        for dns_key, dns_value in value.dns_records : {
          zone_id = dns_value.zone_id
          name    = dns_key == "apex" ? format("%s", dns_value.zone) : format("%s.%s", dns_key, dns_value.zone)
          proxied = true
          value   = module.windows_web_apps.web_app[key].default_hostname
          type    = dns_value.type
          ttl     = 1
        } if dns_value.cloudflare_protected == true
      ]
    ]) : dns_record.name => dns_record
  }


}
