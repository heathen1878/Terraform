resource "azurecaf_name" "resource_group" {
    name = local.subscriptionAndEnvironmentAndLocationUnique
    resource_type = "azurerm_resource_group"
    suffixes = [ var.namespace ]
}

resource "azurecaf_name" "virtual_network" {
    name = local.resourceGroupUnique
    resource_type = "azurerm_virtual_network"
    suffixes = [ var.namespace ]
}

resource "azurecaf_name" "network_security_group" {
    name = local.resourceGroupUnique
    resource_type = "azurerm_network_security_group"
}