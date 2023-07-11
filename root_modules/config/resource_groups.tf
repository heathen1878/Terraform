locals {

  resource_groups = {
    backend = {
      name = "backend"
      tags = {
        usage = "Backend resources"
      }
    }
    environment = {
      name = "environment"
      tags = {
        usage = "Environment resources"
      }
    }
    frontend = {
      name = "frontend"
      tags = {
        usage = "Frontend resources"
      }
    }
  }

  resource_groups_outputs = {
    for key, value in local.resource_groups : key => {
      name     = azurecaf_name.resource_group[key].result
      iam      = lookup(value, "iam", {})
      location = var.location
      tags = merge(
        {
          environment = var.environment
          namespace   = var.namespace
          location    = var.location
        },
        lookup(value, "tags", {}),
        var.tags
      )
    }
  }

}