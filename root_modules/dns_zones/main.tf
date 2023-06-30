module "dns" {
  source  = "heathen1878/dns/azurerm"
  version = "1.0.0"

  private_dns_zones = local.private_dns_zones
  public_dns_zones  = local.public_dns_zones
}

locals {

  private_dns_zones = {
    for key, value in data.terraform_remote_state.config.outputs.dns.private_dns_zones : key => {
      name                 = value.name
      resource_group_name  = module.resource_groups.resource_group[value.resource_group].name
      tags                 = value.tags
      virtual_network_name = module.networking.virtual_network["environment"].name
      virtual_network_id   = module.networking.virtual_network["environment"].id
    }
  }

  # TODO: if there are azure managed dns zones then add subdomains for environments other than production.
  public_dns_zones = {}

}