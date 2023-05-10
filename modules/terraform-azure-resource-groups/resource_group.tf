resource "azurerm_resource_group" "resource_group" {
  for_each = var.resource_groups

  name     = each.value.name
  location = each.value.location
  tags = each.value.tags

}

locals {

  resource_group_outputs = {
    for resource_group_key, resource_group_value in azurerm_resource_group.resource_group : resource_group_key => {
      name     = resource_group_value.name
      location = resource_group_value.location
    }
  }

}