module "azure_nameservers" {
  source  = "heathen1878/dns/ionos"
  version = "1.0.0"

  dns_record = local.azure_nameservers
}

module "cloudflare_nameservers" {
  source  = "heathen1878/dns/ionos"
  version = "1.0.0"

  dns_record = data.terraform_remote_state.global_dns_zones.outputs.dns.name_servers.cloudflare

}

locals {

  azure_nameservers = {
    for key, value in data.terraform_remote_state.global_dns_zones.outputs.dns.name_servers.azure : key => {
      zone_name = value.zone_name
      name      = value.name
      type      = value.type
      content   = value.content
      ttl       = 86400
    }
  }

  cloudflare_nameservers = {
    for key, value in data.terraform_remote_state.global_dns_zones.outputs.dns.name_servers.cloudflare : key => {
      zone_name = value.zone_name
      name      = value.name
      type      = value.type
      content   = value.content
      ttl       = 86400
    }
  }

}
