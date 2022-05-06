# Generate a service principal secret if time rotation has passed
resource "azuread_application_password" "aad_application" {
  for_each = data.terraform_remote_state.aad.outputs.aad_applications

  display_name          = "tf-generated"
  application_object_id = each.value.object_id
  end_date_relative     = format("%sh", each.value.expire_secret_after * 24)
  rotate_when_changed = {
    rotation = time_rotating.secret_rotation[each.value.display_name].id
  }

}

resource "azurerm_key_vault_secret" "aad_application_secret" {
  for_each = local.aad_application_secret_kv_locations_map.aad_application_secret_kv_locations

  name            = format("%s-AAD-secret", each.value.secret_display_name)
  value           = azuread_application_password.aad_application[each.value.aad_sp].value
  key_vault_id    = azurerm_key_vault.key_vault[each.value.kv].id
  content_type    = "AAD application secret"
  expiration_date = time_offset.secret_expiry[each.value.aad_sp].rfc3339

}

resource "azurerm_key_vault_secret" "aad_user_password" {
  for_each = local.aad_users_secret_kv_locations_map.aad_user_secret_kv_locations

  name            = format("%s-AAD-user-password", each.value.user_principal_name)
  value           = each.value.password
  key_vault_id    = azurerm_key_vault.key_vault[each.value.kv].id
  content_type    = "AAD User password"
  expiration_date = each.value.expiration_date
}

resource "azurerm_key_vault_secret" "ssh_keys" {
  for_each = local.aad_users_generate_ssh_keys_map

  name         = format("%s-ssh-private-key", each.value.user)
  value        = base64encode(file(format(".\\keys\\%s.pem", each.value.filename)))
  key_vault_id = azurerm_key_vault.key_vault[each.value.kv].id
  content_type = "SSH Private Key"

  depends_on = [
    null_resource.ssh_keys
  ]

}

resource "azurerm_key_vault_secret" "public_ssh_key" {
  for_each = local.aad_users_generate_ssh_keys_map

  name         = format("%s-ssh-public-key", each.value.user)
  value        = base64encode(file(format(".\\keys\\%s.pub", each.value.filename)))
  key_vault_id = azurerm_key_vault.key_vault[each.value.kv].id
  content_type = "SSH Public Key"

  depends_on = [
    null_resource.ssh_keys
  ]

}


resource "azurerm_key_vault_secret" "ssh_key_passphrase" {
  for_each = local.aad_users_generate_ssh_keys_map

  name         = format("%s-ssh-private-key-passphrase", each.value.user)
  value        = random_password.ssh_keys[each.key].result
  key_vault_id = azurerm_key_vault.key_vault[each.value.kv].id
  content_type = "SSH Private Key Passphrase"

}