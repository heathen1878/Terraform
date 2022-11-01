resource "azurerm_resource_group" "resource_group" {
  for_each = data.terraform_remote_state.config.outputs.resource_groups
  
  name = each.value.name
  location = var.location
  tags = merge(var.tags, {
    location = var.location
    environment = var.environment
    namespace = var.namespace
  })

}

locals {
  
  resource_group_outputs = {
    for resource_group_key, resource_group_value in azurerm_resource_group.resource_group : resource_group_key => {
      name = resource_group_value.name
      location = resource_group_value.location
    }
  }

}