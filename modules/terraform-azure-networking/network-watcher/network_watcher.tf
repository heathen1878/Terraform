resource "azurerm_network_watcher" "network_watcher" {
  for_each = var.network_watcher

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  tags                = each.value.tags
}