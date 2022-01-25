resource "azurerm_resource_group" "resourceGroup_std" {
    name = azurecaf_name.resourceGroup_std.result
    location = var.location
    tags = var.tags
}

resource "azurerm_resource_group" "resourceGroup_providerFeatures" {
    name = azurecaf_name.resourceGroup_providerFeatures.result
    location = var.location
    tags = var.tags
    provider = azurerm.prevent-rg-deletion-if-not-empty
}