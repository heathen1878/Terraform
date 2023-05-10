resource "azurerm_service_plan" "service_plan" {
  for_each = var.service_plans

  # Required
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  os_type             = each.value.os_type
  sku_name            = each.value.sku_name

  # Optional
  worker_count             = each.value.worker_count
  per_site_scaling_enabled = each.value.per_site_scaling_enabled
  zone_balancing_enabled   = each.value.zone_balancing_enabled

}