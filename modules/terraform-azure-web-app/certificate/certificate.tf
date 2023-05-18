resource "azurerm_app_service_certificate" "certificate" {
  for_each = var.certificates

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  app_service_plan_id = each.value.app_service_plan_id
  key_vault_secret_id = each.value.key_vault_secret_id
}