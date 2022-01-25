resource "azurecaf_name" "resourceGroup_std" {
    name = lower(random_id.resourceGroup.id)
    resource_type = "azurerm_resource_group"
    suffixes = [var.usage]
}

resource "azurecaf_name" "resourceGroup_providerFeatures" {
    name = lower(random_id.resourceGroup.id)
    resource_type = "azurerm_resource_group"
    suffixes = ["ft", var.usage]
}

