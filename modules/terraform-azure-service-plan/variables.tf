variable "service_plans" {
  description = "A map of Windows service plans"
  default     = {}
  type = map(object(
    {
      name                         = string
      resource_group_name          = string
      location                     = string
      os_type                      = string
      sku_name                     = string
      maximum_elastic_worker_count = number
      per_site_scaling_enabled     = bool
      tags                         = map(any)
      worker_count                 = number
      zone_balancing_enabled       = bool
    }
  ))

}