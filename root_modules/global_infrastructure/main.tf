module "resource_groups" {
  source = "../../modules/terraform-azure-resource-group"

  resource_groups = data.terraform_remote_state.global_config.outputs.resource_groups
}

module "network_watcher" {
  source = "../../modules/terraform-azure-networking/network-watcher"

  network_watcher = local.network_watcher
}

module "virtual_network" {
  source = "../../modules/terraform-azure-networking/vnets"

  virtual_networks = local.virtual_network
}


locals {

  network_watcher = {
    for key, value in data.terraform_remote_state.global_config.outputs.network_watcher : key => {
      name                = value.name
      resource_group_name = module.resource_groups.resource_group[value.resource_group].name
      location            = value.location
      tags                = value.tags
    }
  }

  virtual_network = {
    for key, value in data.terraform_remote_state.global_config.outputs.virtual_network : key => {
      name                = value.name
      resource_group_name = module.resource_groups.resource_group[value.resource_group].name
      location            = value.location
      address_space       = value.address_space
      dns_servers         = value.dns_servers
      tags                = value.tags
    }
  }

}