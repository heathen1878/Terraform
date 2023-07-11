locals {

  resource_groups = {
    global = {
      tags = {
        Usage = "Global resources"
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
          namespace = var.namespace
          location  = var.location
        },
        lookup(value, "tags", {}),
        var.tags
      )
    }
  }

}