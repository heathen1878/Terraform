module "azure_nameservers" {
  source  = "heathen1878/dns/ionos"
  version = "1.0.0"

  dns_record = data.terraform_remote_state.global_dns_zones.outputs.dns.name_servers.azure
}

module "cloudflare_nameservers" {
  source  = "heathen1878/dns/ionos"
  version = "1.0.0"

  dns_record = data.terraform_remote_state.global_dns_zones.outputs.dns.name_servers.cloudflare

}