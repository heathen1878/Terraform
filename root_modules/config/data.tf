data "azurerm_subscription" "current" {
}

data "azurerm_key_vault" "bootstrap_key_vault" {
  provider = azurerm.mgmt

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

data "terraform_remote_state" "global_config" {
  backend = "azurerm"

  config = {
    storage_account_name = var.state_storage_account
    container_name       = format("%s-%s", var.tenant_id, var.location)
    key                  = "global_config.tfstate"
  }

}

data "terraform_remote_state" "global_infrastructure" {
  backend = "azurerm"

  config = {
    storage_account_name = var.state_storage_account
    container_name       = format("%s-%s", var.tenant_id, var.location)
    key                  = "global_infrastructure.tfstate"
  }

}