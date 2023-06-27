locals {

  # Private zone names can be found here: https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration
  private_dns_zones = {
    azure_automation = {
      name = "privatelink.azure-automation.net"
    }
    database_windows   = {}
    blob_core_windows  = {}
    table_core_windows = {}
    queue_core_windows = {}
    file_core_windows  = {}
    web_core_windows   = {}
    key_vault = {
      name = "privatelink.vaultcore.azure.net"
    }
    search_windows      = {}
    servicebus          = {}
    azurewebsites       = {}
    scm_azurewebsites   = {}
    redis_cache_windows = {}
  }

  private_dns_zone_outputs = {
    for key, value in local.private_dns_zones : key => {
      name           = lookup(value, "name", format("privatelink.%s.net", replace(key, "_", ".")))
      resource_group = lookup(value, "resource_group", "global")
      tags = {
        IaC         = "Terraform"
        environment = var.environment
        namespace   = var.namespace
      }
    }
  }

  azure_managed_zones = {
    for key, value in var.dns_zones : key => {
      name           = value.name
      resource_group = value.resource_group
      tags = merge(
        var.tags, {
          environment = var.environment
          namespace   = var.namespace
          location    = "global"
        },
        lookup(value, "tags", {})
      )
      associated_web_apps = value.associated_web_apps
    } if value.azure_managed == true
  }

  cloudflare_protected_zones = {
    for key, value in var.dns_zones : key => {
      account_name        = var.cloudflare_account_name
      zone                = value.name
      jump_start          = value.jump_start
      paused              = value.paused
      plan                = value.plan
      type                = value.type
      associated_web_apps = value.associated_web_apps
    } if value.cloudflare_protected == true
  }

  zone_and_web_app_association = {
    for web_app in flatten([
      for key, value in var.dns_zones : [
        for web_app_key in value.associated_web_apps : {
          web_app = web_app_key
          zone    = key
        }
      ] if lookup(value, "associated_web_apps", []) != []
    ]) : format("%s_%s", web_app.web_app, web_app.zone) => web_app
  }


  azure_dns_records = {
    for key, value in var.dns_records : key => {
      associated_web_app = value.associated_web_app
      type               = value.type
      ttl                = value.ttl
      zone               = value.zone_key
    } if value.azure_managed == true
  }

  cloudflare_protected_dns_records = {
    for key, value in var.dns_records : key => {
      associated_web_app = value.associated_web_app
      type               = value.type
      ttl                = value.proxy_status == true ? 1 : value.ttl
      proxied            = value.proxy_status
      zone               = value.zone_key
    } if value.cloudflare_protected == true
  }

}