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

  dns_records = {
    www = {
      content = "demo"
    }
  }

  env_dns_records = merge(
    local.dns_records,
    var.cloudflare_dns_records
  )

  env_dns_records_output = {
    for key, value in local.env_dns_records : key => {
      content      = lookup(value, "content", "app_gateway_key")
      type         = lookup(value, "type", "A")
      ttl          = lookup(value, "ttl", 3600)
      proxy_status = lookup(value, "proxy_status", true)
      zone         = lookup(value, "zone", "")
    }
  }

}
