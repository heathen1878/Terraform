data "azuread_client_config" "current" {
}

data "azurerm_subscription" "current" {
}

data "azurerm_key_vault" "bootstrap_key_vault" {
  name                = var.bootstrap.key_vault.name
  resource_group_name = var.bootstrap.key_vault.resource_group
}

data "azurerm_key_vault_secret" "aci_pat_token" {
  name         = "azdo-pat-token-aci"
  key_vault_id = data.azurerm_key_vault.bootstrap_key_vault.id
}

data "azurerm_key_vault_secret" "azdo_service_url" {
  name         = "azdo-service-url"
  key_vault_id = data.azurerm_key_vault.bootstrap_key_vault.id
}

data "http" "azure_service_tags" {
  url = format("https://management.azure.com/subscriptions/%s/providers/Microsoft.Network/locations/%s/serviceTags?api-version=2022-07-01", data.azurerm_subscription.current.subscription_id, local.location)

  request_headers = {
    "Authorization" = format("Bearer %s", var.access_token)
  }

}

locals {

  all_addresses = jsondecode(data.http.azure_service_tags.response_body)

  azure_frontdoor_backend = {
    for value in local.all_addresses.values : value.id => {
      name   = value.name
      region = value.properties.region != "" ? value.properties.region : "global"
      address_prefixes = [
        #only IPv4 addresses are supported.
        for address_prefix in value.properties.addressPrefixes : address_prefix if length(regexall("^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(/(3[0-2]|2[0-9]|1[0-9]|[0-9]))?$", address_prefix)) == 1
      ]
    } if value.name == "AzureFrontDoor.Backend"
  }


}