resource "azurerm_resource_group" "resourceGroup" {
    name = azurecaf_name.resourceGroup.result
    location = var.location
    tags = var.tags
}

resource "azurerm_resource_group" "resourceGroup" {
    name = azurecaf_name.resourceGroup.result
    location = var.location
    tags = var.tags
    provider = prevent_rg_deletion_if_not_empty
}