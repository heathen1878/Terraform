module "dns" {
  source  = "heathen1878/dns/azurerm"
  version = "1.0.1"

  private_dns_zones = local.private_dns_zones
  public_dns_zones  = local.public_dns_zones
}

locals {

  private_dns_zones = {
    for key, value in data.terraform_remote_state.config.outputs.dns.private_dns_zones : key => {
      name                 = value.name
      resource_group_name  = data.terraform_remote_state.infrastructure.outputs.resource_groups[value.resource_group].name
      tags                 = value.tags
      virtual_network_name = data.terraform_remote_state.infrastructure.outputs.virtual_networks["environment"].name
      virtual_network_id   = data.terraform_remote_state.infrastructure.outputs.virtual_networks["environment"].id
    }
  }

  public_dns_zones = {
    for key, value in data.terraform_remote_state.config.outputs.dns.subdomains : key => {
      name                          = data.terraform_remote_state.global_dns_zones.outputs.dns.zones.azure[value.name].name
      resource_group_name           = data.terraform_remote_state.global_dns_zones.outputs.dns.zones.azure[value.name].resource_group_name
      subdomain                     = value.subdomain
      subdomain_resource_group_name = data.terraform_remote_state.infrastructure.outputs.resource_groups[value.resource_group].name
      ttl                           = value.ttl
      tags                          = value.tags
    }
  }

}