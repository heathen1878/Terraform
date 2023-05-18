locals {

  resource_groups = {
    demo = {
      name = "demo"
    }
    management = {
      name = "management"
    }
    infrastructure = {
      name = "infrastructure"
    }
    frontend = {
      name = "frontend"
    }
    backend = {
      name = "backend"
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