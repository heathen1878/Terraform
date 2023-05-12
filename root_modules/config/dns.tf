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
    } if value.azure_managed == true
  }

  cloudflare_protected_zones = {
    for key, value in var.dns_zones : key => {
      account_name = var.cloudflare_account_name
      zone         = value.name
      jump_start   = value.jump_start
      paused       = value.paused
      plan         = value.plan
      type         = value.type
    } if value.cloudflare_protected == true
  }

  azure_dns_records = {
    for key, value in var.dns_records : key => {
      content = value.content
      type    = value.type
      ttl     = value.ttl
      zone    = value.zone_key
    } if value.azure_managed == true
  }

  cloudflare_protected_dns_records = {
    for key, value in var.dns_records : key => {
      content = value.content
      type    = value.type
      ttl     = value.proxy_status == true ? 1 : value.ttl
      proxied = value.proxy_status
      zone    = value.zone_key
    } if value.cloudflare_protected == true
  }

}
