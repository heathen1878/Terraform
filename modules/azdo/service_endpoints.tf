resource "azuredevops_serviceendpoint_dockerregistry" "acrs" {
  for_each = data.terraform_remote_state.container_registry.outputs.acr_dockerhub

  project_id            = azuredevops_project.devops_projects[each.value.project_key].id
  description           = each.value.description
  service_endpoint_name = each.value.service_endpoint_name
  docker_registry       = each.value.docker_registry
  docker_username       = each.value.docker_username
  docker_password       = each.value.docker_password
  registry_type         = "Others"
}

resource "azuredevops_serviceendpoint_azurerm" "azurerm" {
  for_each = data.terraform_remote_state.global.outputs.aad_application_service_connections

  project_id = azuredevops_project.devops_projects[each.value.project_key].id
  description = each.value.description
  service_endpoint_name = each.value.service_endpoint_name
  credentials {
    serviceprincipalid = each.value.service_principal_id
    serviceprincipalkey = each.value.secret
  }
  azurerm_spn_tenantid = each.value.tenant_id
  azurerm_management_group_id = each.value.management_group_id
  azurerm_management_group_name = each.value.management_group_name

}
