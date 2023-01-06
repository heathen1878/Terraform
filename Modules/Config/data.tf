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