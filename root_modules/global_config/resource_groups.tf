locals {

  resource_groups = {
    management = {
    }
    management2 = {
      iam = {
        readers = {
          role_definition_id = "acdd72a7-3385-48ef-bd42-f606fba81ae7"
          principal_id       = "bdde475c-f254-44b0-b48d-65ad83bffa4e"
        }
        contributors = {
          role_definition_id = "b24988ac-6180-42a0-ab88-20f7382dd24c"
          principal_id       = "bdde475c-f254-44b0-b48d-65ad83bffa4e"
        }
      }
    }
  }

  resource_groups_outputs = {
    for key, value in local.resource_groups : key => {
      name     = azurecaf_name.resource_group[key].result
      location = var.location
      tags = merge(var.tags,
        lookup(value, "tags", {
          usage     = key
          namespace = var.namespace
        })
      )
      iam = lookup(value, "iam", {})
    }
  }

}