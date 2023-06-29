locals {

  azure_managed_zones = {
    for key, value in var.dns_zones : key => {
      name           = value.name
      resource_group = value.resource_group
      tags = merge(
        var.tags, {
          namespace = var.namespace
          location  = "global"
        },
        lookup(value, "tags", {})
      )
    } if value.azure_managed == true
  }

  cloudflare_protected_zones = {
    for key, value in var.dns_zones : key => {
      account_id = data.cloudflare_accounts.account.accounts[0].id
      zone       = value.name
      jump_start = value.jump_start
      paused     = value.paused
      plan       = value.plan
      type       = value.type
    } if value.cloudflare_protected == true
  }

}