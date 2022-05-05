resource "azurecaf_name" "resourceGroup" {
    name = lower(random_id.subscriptionAndEnvironmentAndLocationUnique.id)
    resource_type = "azurerm_resource_group"
    suffixes = [ var.usage ]
}

resource "azurecaf_name" "keyVault" {
    name = lower(random_id.subscriptionAndEnvironmentAndLocationUnique.id)
    resource_type = "azurerm_key_vault"
    suffixes = [ var.usage ]
}