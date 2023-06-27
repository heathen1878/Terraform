locals {

  service_plans = {
    #general = {
    #  resource_group = "frontend"
    #}
  }

  service_plan_output = {
    for key, value in local.service_plans : key => {
      name                         = azurecaf_name.service_plans[key].result
      resource_group               = lookup(value, "resource_group", "environment")
      location                     = lookup(value, "location", var.location)
      os_type                      = lookup(value, "os_type", "Windows")
      sku_name                     = lookup(value, "sku_name", "B1")
      auto_scale_default           = lookup(value, "auto_scale_default", 1)
      auto_scale_min               = lookup(value, "auto_scale_min", 1)
      auto_scale_max               = lookup(value, "auto_scale_max", 2)
      maximum_elastic_worker_count = lookup(value, "maximum_elastic_worker_count", 1)
      per_site_scaling_enabled     = lookup(value, "per_site_scaling_enabled", false)
      tags = merge(
        var.tags,
        lookup(value, "tags", {
          environment = var.environment
          namespace   = var.namespace
          location    = var.location
        })
      )
      worker_count           = lookup(value, "worker_count", 1)
      zone_balancing_enabled = lookup(value, "zone_balancing_enabled", false)
    }
  }

}
