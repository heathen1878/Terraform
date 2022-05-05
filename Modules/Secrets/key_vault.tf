resource "azurerm_key_vault" "keyVault" {
    name = azurecaf_name.keyVault.result
    resource_group_name = azurerm_resource_group.resourceGroup.name
    location = var.location
    tenant_id = data.azurerm_client_config.current.tenant_id
    enable_rbac_authorization = true
    sku_name = "standard"
}

resource "azurerm_role_assignment" "keyVaultAdmin" {
  scope = azurerm_key_vault.keyVault.id
  role_definition_name = "Key Vault Administrator"
  principal_id = var.keyVaultAdmin
}

resource "azurerm_role_assignment" "keyVaultSecretsOfficer" {
  scope = azurerm_key_vault.keyVault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id = var.keyVaultSecretsOfficer
}

resource "azurerm_role_assignment" "keyVaultCertificatesOfficer" {
  scope = azurerm_key_vault.keyVault.id
  role_definition_name = "Key Vault Certificates Officer"
  principal_id = var.keyVaultCertificatesOfficer
}