resource "azurerm_resource_group" "resourceGroup" {
    name = azurecaf_name.resourceGroup.result
    location = var.location
    tags = var.tags
}