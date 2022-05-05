/*
NOTES
To maintain naming standards with virtual machines...underscores have been removed from other resources
*/
locals {
    subscriptionAndEnvironmentAndLocationUnique = replace(lower(random_id.subscriptionAndEnvironmentAndLocationUnique.id), "/[^0-9a-zA-Z]/", "")
    subscriptionAndEnvironmentAndLocationUnique_charlimitation = replace(lower(random_id.subscriptionAndEnvironmentAndLocationUnique_charlimitation.id), "/[^0-9a-zA-Z]/", "")
    subscriptionAndLocationUnique = replace(lower(random_id.subscriptionAndLocationUnique.id), "/[^0-9a-zA-Z]/", "")
    resourceGroupUnique = replace(lower(random_id.resourceGroupUnique.id), "/[^0-9a-zA-Z]/", "")
    usage = lower(var.usage)
}

resource "azurecaf_name" "resourceGroup" {
    name = local.subscriptionAndEnvironmentAndLocationUnique
    resource_type = "azurerm_resource_group"
    suffixes = [ local.usage ]
}

resource "azurecaf_name" "networkWatcher" {
    name = local.subscriptionAndLocationUnique
    resource_type = "azurerm_network_watcher"
}

resource "azurecaf_name" "virtualNetwork" {
    name = local.resourceGroupUnique
    resource_type = "azurerm_virtual_network"
    suffixes = ["hub"]
}

resource "azurecaf_name" "networkSecurityGroup" {
    name = local.resourceGroupUnique
    resource_type = "azurerm_network_security_group"
}