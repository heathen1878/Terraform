output "dns" {
  value = {
    name_servers = {
      azure      = local.azure_nameservers
      cloudflare = local.cloudflare_nameservers
    }
    zones = {
      azure      = module.dns.public_dns_zones
      cloudflare = module.cloudflare_zone.zones.zone
    }
  }
}