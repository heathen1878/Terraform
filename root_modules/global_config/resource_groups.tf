locals {

  resource_groups = {
    global = {
    }
    management = {
    }
    management2 = {
      iam = {
        readers = {
          role_definition_name = "Reader"
          principal_id         = "bdde475c-f254-44b0-b48d-65ad83bffa4e"
        }
        contributors = {
          role_definition_name = "Contributor"
          principal_id         = "bdde475c-f254-44b0-b48d-65ad83bffa4e"
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