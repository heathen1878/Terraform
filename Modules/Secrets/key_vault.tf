resource "azurerm_key_vault" "key_vault" {
  for_each = data.terraform_remote_state.config.outputs.key_vaults.vaults

  name                      = each.value.kv_name
  resource_group_name       = data.terraform_remote_state.resource_group.outputs.resource_group[each.value.resource_group_name].name
  location                  = data.terraform_remote_state.resource_group.outputs.resource_group[each.value.resource_group_name].location
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization = true
  sku_name                  = "standard"
  tags = {
    vault = each.key
  }

}

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
