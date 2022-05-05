resource "azurecaf_name" "resourceGroup" {
    name = lower(random_id.subscriptionAndEnvironmentAndLocationUnique.id)
    resource_type = "azurerm_resource_group"
    suffixes = [ var.usage ]
}