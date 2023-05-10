module "resource_groups" {
  source = "../../modules/terraform-azure-resource-group"

  resource_groups = data.terraform_remote_state.config.outputs.resource_groups

}

module "service_plans" {
  source = "../../modules/terraform-azure-service-plan"

  service_plans = local.service_plans

}


locals {

  service_plans = {
    for key, value in data.terraform_remote_state.config.outputs.service_plans : key => {
      name                         = value.name
      resource_group_name          = module.resource_groups.resource_group[value.resource_group].name
      location                     = value.location
      os_type                      = value.os_type
      sku_name                     = value.sku_name
      maximum_elastic_worker_count = value.maximum_elastic_worker_count
      per_site_scaling_enabled     = value.per_site_scaling_enabled
      tags                         = value.tags
      worker_count                 = value.worker_count
      zone_balancing_enabled       = value.zone_balancing_enabled
    }
  }

  windows_web_apps = {
    for key, value in data.terraform_remote_state.config.outputs.web_apps.windows : key => {
      name = value.name
      resource_group_name = module.resource_groups.resource_group[value.resource_group].name
      location = value.location
    }
  }

}