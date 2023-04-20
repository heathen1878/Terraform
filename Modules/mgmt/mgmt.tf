resource "azurerm_management_group" "management_groups" {
  for_each = local.management_groups

  name         = each.key
  display_name = each.value.display_name

  subscription_ids = each.value.subscriptions

}