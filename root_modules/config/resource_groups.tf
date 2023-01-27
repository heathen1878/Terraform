locals {

  resource_groups = {
    demo = {
      name = "demo"
    }
    management = {
      name = "management"
    }
  }

  resource_groups_outputs = {
    for resource_group_key, resource_group_value in local.resource_groups : resource_group_key => {
      name = azurecaf_name.resource_group[resource_group_key].result
    }
  }

}