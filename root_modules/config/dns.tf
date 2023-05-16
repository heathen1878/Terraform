locals {

  azure_managed_zones = {
    for key, value in var.dns_zones : key => {
      name           = value.name
      resource_group = value.resource_group
      tags = merge(
        var.tags,
        lookup(value, "tags", {
          environment = var.environment
          namespace   = var.namespace
        })
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
