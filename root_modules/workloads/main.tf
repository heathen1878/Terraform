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
        data.terraform_remote_state.dns_zones.outputs.dns.zones.private["azurewebsites"].id,
        data.terraform_remote_state.dns_zones.outputs.dns.zones.private["scm_azurewebsites"].id
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
}
