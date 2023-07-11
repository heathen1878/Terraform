module "dns" {
  source  = "heathen1878/dns/azurerm"
  version = "1.0.1"

  private_dns_zones = local.private_dns_zones
  public_dns_zones  = local.public_dns_zones
}

module "cloudflare_zone" {
  source  = "heathen1878/zones/cloudflare"
  version = "1.0.2"

  zones = local.cloudflare_dns_zones
}

locals {

  private_dns_zones = {}

  public_dns_zones = {
    for key, value in data.terraform_remote_state.global_config.outputs.dns.zones : key => {
      name                = value.name
      resource_group_name = data.terraform_remote_state.global_infrastructure.outputs.resource_groups[value.resource_group].name
      tags                = value.tags
    }
  }

  cloudflare_dns_zones = {
    for key, value in data.terraform_remote_state.global_config.outputs.cloudflare.zones : key => value
  }

  azure_nameservers = {
    for nameserver in flatten([
      for key, value in module.dns.public_dns_zones : [
        for ns_value in value.name_servers : {
          zone_key    = replace(value.name, ".", "_")
          content_key = replace(ns_value, ".", "_")
          zone_name   = value.name
          name        = value.name
          type        = "NS"
          content     = ns_value
          ttl         = 3600
        }
      ]
    ]) : format("%s_%s", nameserver.zone_key, nameserver.content_key) => nameserver
  }

  cloudflare_nameservers = {
    for nameserver in flatten([
      for key, value in module.cloudflare_zone.zones.zone : [
        for ns_value in value.name_servers : {
          zone_key    = replace(value.zone, ".", "_")
          content_key = replace(ns_value, ".", "_")
          zone_name   = value.zone
          name        = value.zone
          type        = "NS"
          content     = ns_value
          ttl         = 3600
        }
      ]
    ]) : format("%s_%s", nameserver.zone_key, nameserver.content_key) => nameserver
  }

}