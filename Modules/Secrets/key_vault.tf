resource "azurerm_key_vault" "key_vault" {
    for_each = data.terraform_remote_state.config.outputs.key_vaults
    
    name = each.value.kv_name
    resource_group_name = azurerm_resource_group.resourceGroup.name
    location = var.location
    tenant_id = data.azurerm_client_config.current.tenant_id
    enable_rbac_authorization = true
    sku_name = "standard"
}

resource "azurerm_role_assignment" "keyVaultAdmin" {
  for_each = azurerm_key_vault.key_vault

  scope = each.value.id
  role_definition_name = "Key Vault Administrator"
  principal_id = var.keyVaultAdmin
}

resource "azurerm_role_assignment" "keyVaultSecretsOfficer" {
  for_each = azurerm_key_vault.key_vault

  scope = each.value.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id = var.keyVaultSecretsOfficer
}

resource "azurerm_role_assignment" "keyVaultCertificatesOfficer" {
  for_each = azurerm_key_vault.key_vault

  scope = each.value.id
  role_definition_name = "Key Vault Certificates Officer"
  principal_id = var.keyVaultCertificatesOfficer
}