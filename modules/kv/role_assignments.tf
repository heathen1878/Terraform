resource "azurerm_role_assignment" "key_vault_admin" {
  for_each = azurerm_key_vault.key_vault

  scope                = each.value.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.terraform_remote_state.aad.outputs.key_vault_groups["key-vault-admin"].object_id
}

resource "azurerm_role_assignment" "key_vault_secrets_officer" {
  for_each = azurerm_key_vault.key_vault

  scope                = each.value.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.terraform_remote_state.aad.outputs.key_vault_groups["secrets-officer"].object_id
}

resource "azurerm_role_assignment" "key_vault_certificates_officer" {
  for_each = azurerm_key_vault.key_vault

  scope                = each.value.id
  role_definition_name = "Key Vault Certificates Officer"
  principal_id         = data.terraform_remote_state.aad.outputs.key_vault_groups["certificates-officer"].object_id
}
