resource "azurerm_role_assignment" "keyVaultAdmin" {
  scope = azurerm_key_vault.keyVault.id
  role_definition_name = "Key Vault Administrator"
  principal_id = var.keyVaultAdmin
  depends_on = [
      azurerm_key_vault.keyVault
  ]
}

resource "azurerm_role_assignment" "keyVaultSecretsOfficer" {
  scope = azurerm_key_vault.keyVault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id = var.keyVaultSecretsOfficer
  depends_on = [
      azurerm_key_vault.keyVault
  ]
}

resource "azurerm_role_assignment" "keyVaultCertificatesOfficer" {
  scope = azurerm_key_vault.keyVault.id
  role_definition_name = "Key Vault Certificates Officer"
  principal_id = var.keyVaultCertificatesOfficer
  depends_on = [
      azurerm_key_vault.keyVault
  ]
}
