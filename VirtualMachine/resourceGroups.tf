resource "azurerm_resource_group" "resourceGroup" {
    name = azurecaf_name.resourceGroup.result
    location = var.location
    tags = var.tags
}
resource "azurerm_resource_group" "nwResourceGroup" {
    name = azurecaf_name.nwResourceGroup.result
    location = var.location
    tags = var.tags
}