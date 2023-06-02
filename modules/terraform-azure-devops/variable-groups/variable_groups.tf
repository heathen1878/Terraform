resource "azuredevops_variable_group" "variable_group" {
    for_each = var.variable_groups

    project_id = each.value.project_id
    name = each.value.name
    description = each.value.description
    allow_access = each.value.allow_access

    key_vault {
      name = each.value.key_vault_name
      service_endpoint_id = each.value.service_endpoint_id
    }

    dynamic "variable" {
    for_each = {
      for key, value in each.value : key => value
      if startswith(key, "var_")
    }

    content {
      # NOTE depending if the value is secret or not it is set with a complementary attribute
      name         = substr(variable.key, 4, -1)
      value        = length(regexall("password", variable.key)) > 0 ? null : variable.value
      is_secret    = length(regexall("password", variable.key)) > 0 ? true : false
      secret_value = length(regexall("password", variable.key)) > 0 ? variable.value : null
    }
  }

}