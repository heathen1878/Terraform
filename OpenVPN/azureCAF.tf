resource "azurecaf_name" "resourceGroup" {
    name = lower(random_id.resourceGroup.id)
    resource_type = "azurerm_resource_group"
    suffixes = [ var.usage ]
}

resource "azurecaf_name" "networkWatcher" {
    name = lower(random_id.networkWatcher.id)
    resource_type = "azurerm_network_watcher"
}

resource "azurecaf_name" "virtualNetwork" {
    name = lower(random_id.virtualNetwork.id)
    resource_type = "azurerm_virtual_network"
    suffixes = ["hub"]
}

resource "azurecaf_name" "availabilitySet" {
    name = lower(random_id.availabilitySet)
    resource_type = "azurerm_availability_set"
    suffixes = [ var.usage ]
}

resource "azurecaf_name" "networkAdapter" {
    name = lower(random_id.networkAdapter)
    resource_type = azurerm_network_interface
}