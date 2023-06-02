resource "azuredevops_serviceendpoint_azurerm" "service_endpoint" {
  for_each = var.azurerm_service_endpoint

  project_id            = each.value.project_id
  description           = each.value.description
  service_endpoint_name = each.value.service_endpoint_name
  credentials {
    serviceprincipalid  = each.value.credentials.service_principal_id
    serviceprincipalkey = each.value.credentials.secret
  }
  azurerm_spn_tenantid          = each.value.tenant_id
  azurerm_management_group_id   = each.value.management_group_id
  azurerm_management_group_name = each.value.management_group_name
}