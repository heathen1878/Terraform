variable "azurerm_service_endpoint" {
  description = "A map of AzureRM service endpoints"
  type = map(object(
    {
      project_id            = string
      description           = string
      service_endpoint_name = string
      credentials = object({
        serviceprincipalid  = string
        serviceprincipalkey = string
      })
      azurerm_spn_tenantid          = string
      azurerm_management_group_id   = string
      azurerm_management_group_name = string
    }
  ))
}