resource "azurerm_resource_group" "resource_group" {
  name = data.terraform_remote_state.config.outputs.key_vaults.resource_group_name
  location = var.location
  tags = merge(var.tags, {
    location = var.location
    environment = var.environment
  })

}

resource "azurerm_key_vault" "key_vault" {
  for_each = data.terraform_remote_state.config.outputs.key_vaults.vaults
    
  name = each.value.kv_name
  resource_group_name = each.value.resource_group_name
  location = var.location
  tenant_id = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization = true
  sku_name = "standard"
  tags = {
    vault = each.key
  }
  

  depends_on = [
    azurerm_resource_group.resource_group
  ]

}

resource "azurerm_role_assignment" "key_vault_admin" {
  for_each = azurerm_key_vault.key_vault

  scope = each.value.id
  role_definition_name = "Key Vault Administrator"
  principal_id = data.terraform_remote_state.aad.outputs.key_vault_groups[format("%s-%s-key-vault-admins",  var.namespace, var.environment)].object_id
}

resource "azurerm_role_assignment" "key_vault_secrets_officer" {
  for_each = azurerm_key_vault.key_vault

  scope = each.value.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id = data.terraform_remote_state.aad.outputs.key_vault_groups[format("%s-%s-secret-officers",  var.namespace, var.environment)].object_id
}

resource "azurerm_role_assignment" "key_vault_certificates_officer" {
  for_each = azurerm_key_vault.key_vault

  scope = each.value.id
  role_definition_name = "Key Vault Certificates Officer"
  principal_id = data.terraform_remote_state.aad.outputs.key_vault_groups[format("%s-%s-certificate-officers",  var.namespace, var.environment)].object_id
}