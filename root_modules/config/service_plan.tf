locals {

  service_plans = {
    default = {
    }
  }

  service_plan_output = {
    for key, value in local.service_plans : key => {
      name           = azurecaf_name.service_plans[key].result
      resource_group = lookup(value, "resource_group", "demo")
      location = lookup(value, "location", var.location)
      os_type        = lookup(value, "os_type", "Windows")   
      sku_name       = lookup(value, "sku_name", "B1")
      maximum_elastic_worker_count = lookup(value, "maximum_elastic_worker_count", null)
      per_site_scaling_enabled = lookup(value, "per_site_scaling_enabled", false)
      tags = merge(
        var.tags,
        lookup(value, "tags", {
          environment = var.environment
          namespace = var.namespace
        })
      )
      worker_count = lookup(value, "worker_count", null)
      zone_balancing_enabled = lookup(value, "zone_balancing_enabled", false)
    }
  }

}
