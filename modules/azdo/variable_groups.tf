#resource "azuredevops_variable_group" "variable_group" {
#    for_each = ...
#
#    project_id = azuredevops_project.devops_projects[each.value.project_id].id
#    name = each.value.name
#    description = each.value.description
#    allow_access = each.value.allow_access
#
#    key_vault {
#      name = each.value.key_vault_name
#      service_endpoint_id = azuredevops_serviceendpoint_azurerm.azurerm[each.key].id
#    }
#
#    variable {
#      name = ""
#    }
#
#    variable {
#      name = ""
#    }
#
#}