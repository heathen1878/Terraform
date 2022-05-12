resource "azurecaf_name" "global_resource_group" {
    name = local.subscriptionAndLocationUnique
    resource_type = "azurerm_resource_group"
}

resource "azurecaf_name" "network_watcher" {
    name = local.subscriptionAndLocationUnique
    resource_type = "azurerm_network_watcher"
}
