locals {

  service_plans = {
    general = {
      resource_group = "frontend"
      sku_name       = "S2"
    }
  }

  premium_service_plans = {
    EP1 = {
      resource_group = "backend"
      sku_name       = "EP1"
    }
    EP2 = {
      resource_group = "backend"
      sku_name       = "EP2"
    }
    EP3 = {
      resource_group = "backend"
      sku_name       = "EP3"
    }
  }

  consumption_service_plans = {
    for key, value in local.windows_function_apps : key => {
      resource_group = value.resource_group
      sku_name       = value.sku
    } if value.sku == "Y1"
  }

  service_plan_output = {
    for key, value in local.service_plans : key => {
      name                         = azurecaf_name.service_plan[key].result
      resource_group               = lookup(value, "resource_group", "environment")
      location                     = lookup(value, "location", var.location)
      os_type                      = lookup(value, "os_type", "Windows")
      sku_name                     = lookup(value, "sku_name", "B1")
      auto_scale_default           = lookup(value, "auto_scale_default", 1)
      auto_scale_min               = lookup(value, "auto_scale_min", 1)
      auto_scale_max               = lookup(value, "auto_scale_max", 2)
      maximum_elastic_worker_count = null
      per_site_scaling_enabled     = lookup(value, "per_site_scaling_enabled", false)
      tags = merge(
        {
          environment = var.environment
          namespace   = var.namespace
          location    = var.location
        },
        lookup(value, "tags", {}),
        var.tags
      )
      worker_count           = lookup(value, "worker_count", 1)
      zone_balancing_enabled = lookup(value, "zone_balancing_enabled", false)
    }
  }

  consumption_service_plan_output = {
    for key, value in local.consumption_service_plans : key => {
      name                         = azurecaf_name.consumption_service_plan[key].result
      resource_group               = value.resource_group
      location                     = var.location
      os_type                      = lookup(value, "os_type", "Windows")
      sku_name                     = value.sku_name
      auto_scale_default           = lookup(value, "auto_scale_default", 1)
      auto_scale_min               = lookup(value, "auto_scale_min", 1)
      auto_scale_max               = lookup(value, "auto_scale_max", 2)
      maximum_elastic_worker_count = null
      per_site_scaling_enabled     = lookup(value, "per_site_scaling_enabled", false)
      tags = merge(
        {
          environment = var.environment
          namespace   = var.namespace
          location    = var.location
        },
        lookup(value, "tags", {}),
        var.tags
      )
      worker_count           = lookup(value, "worker_count", 1)
      zone_balancing_enabled = lookup(value, "zone_balancing_enabled", false)
    }
  }

  # This list grabs all function apps and their specified SKU
  # then it creates a distinct list of elastic premium skus to be created
  premium_plans_to_create = distinct([
    for value in local.windows_function_apps : value.sku
    if value.sku != "Y1"
  ])

  premium_service_plan_output = {
    for key, value in local.premium_service_plans : key => {
      name                         = azurecaf_name.premium_service_plan[key].result
      resource_group               = value.resource_group
      location                     = var.location
      os_type                      = lookup(value, "os_type", "Windows")
      sku_name                     = value.sku_name
      auto_scale_default           = lookup(value, "auto_scale_default", 1)
      auto_scale_min               = lookup(value, "auto_scale_min", 1)
      auto_scale_max               = lookup(value, "auto_scale_max", 2)
      maximum_elastic_worker_count = lookup(value, "maximum_elastic_worker_count", 1)
      per_site_scaling_enabled     = lookup(value, "per_site_scaling_enabled", false)
      tags = merge(
        {
          environment = var.environment
          namespace   = var.namespace
          location    = var.location
        },
        lookup(value, "tags", {}),
        var.tags
      )
      worker_count           = lookup(value, "worker_count", 1)
      zone_balancing_enabled = lookup(value, "zone_balancing_enabled", false)
    } if contains(local.premium_plans_to_create, key)
  }



}
