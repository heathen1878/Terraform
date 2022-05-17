resource "azurerm_resource_group" "resource_group" {
    name = azurecaf_name.global_resource_group.result
    location = var.location
    tags = var.tags
}


resource "azurerm_network_watcher" "network_watcher" {
    name = azurecaf_name.network_watcher.result
    location = var.location
    resource_group_name = azurerm_resource_group.resource_group.name
    tags = merge(var.tags, {
        location = var.location
        }
    )
}