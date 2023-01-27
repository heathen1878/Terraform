resource "azurerm_management_group" "management_groups" {
  for_each = local.management_groups

  name         = each.key
  display_name = each.value.display_name

  subscription_ids = each.value.subscriptions

}

locals {

  # if there is a devops project specified alongside a management group then create a map for each project defined.
  # This will then be used by the azdo module to create a management group scoped service connection per project.


  aad_applications_service_connection_output = {
    for aad_app_key, aad_app_value in local.aad_applications_config_output : aad_app_key => {
      management_group_name = azurerm_management_group.management_groups[aad_app_value.management_group].display_name
      management_group_id   = azurerm_management_group.management_groups[aad_app_value.management_group].id
      projects              = aad_app_value.azdo_projects
      service_endpoint_name = replace(aad_app_value.display_name, " ", "-")
      service_principal_id  = azuread_service_principal.aad_application_principal[aad_app_key].object_id
      secret                = azuread_application_password.aad_application[aad_app_key].value
      tenant_id             = var.tenant_id
    } if lookup(aad_app_value, "management_group", "") != ""
  }

}