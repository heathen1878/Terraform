locals {

  resource_groups = {
    backend = {
      name = "backend"
    }
    environment = {
      name = "environment"
    }
    frontend = {
      name = "frontend"
    }
    global = {
    }
    az_104 = {
      name = "az-104"
    }
  }

  resource_groups_outputs = {
    for key, value in local.resource_groups : key => {
      name     = azurecaf_name.resource_group[key].result
      location = var.location
      tags = merge(var.tags,
        lookup(value, "tags", {
          usage       = key
          namespace   = var.namespace
          environment = var.environment
        })
      )
    }
  }

}