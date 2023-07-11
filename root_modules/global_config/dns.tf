locals {

  azure_managed_zones = {
    for key, value in var.dns_zones : key => {
      name           = value.name
      resource_group = value.resource_group
      tags = merge(
        {
          namespace = var.namespace
          location  = var.location
        },
        lookup(value, "tags", {}),
        var.tags
      )
    } if value.azure_managed == true
  }

  cloudflare_protected_zones = {
    for key, value in var.dns_zones : key => {
      account_id = data.cloudflare_accounts.account.accounts[0].id
      zone       = value.name
      hosts = [
        format("*.%s", value.name),
        format("*.dev.%s", value.name),
        format("*.dom.%s", value.name),
        format("*.tst.%s", value.name),
        format("*.stg.%s", value.name)
      ]
      jump_start = value.jump_start
      paused     = value.paused
      plan       = value.plan
      type       = value.type
    } if value.cloudflare_protected == true
  }

  domains = {
    for key, value in var.dns_zones : key => {
      name = value.name
    }
  }


}