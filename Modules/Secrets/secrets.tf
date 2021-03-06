locals {

    # AAD applications secret kv locations
    aad_application_secret_kv_locations = flatten([
        for aad_app_key, aad_app_value in data.terraform_remote_state.aad.outputs.aad_applications : [
            for aad_kv_location_key, aad_kv_location_value in aad_app_value.kv : {
                secret                           = aad_app_value.secret
                secret_display_name              = aad_app_value.secret_display_name
                kv                               = aad_kv_location_value
                secret_expiration                = aad_app_value.secret_expiration
            }
        ]
        if lookup(aad_app_value, "service_principal_secret_kv", []) != []
    ])

    aad_application_secret_kv_locations_map = {
        aad_application_secret_kv_locations = {
        for aad_key, aad_value in local.aad_application_secret_kv_locations : format("%s_%s", aad_value.aad_sp, aad_value.kv) => aad_value
        }
    }

    aad_users_secret_kv_locations = flatten([
        for aad_user_key, aad_user_value in data.terraform_remote_state.config.outputs.aad_users : [
            for aad_kv_location_key, aad_kv_location_value in aad_user_value.kv : {
                key                             = aad_user_key
                domain_suffix                   = aad_user_value.domain_suffix
                kv                              = aad_kv_location_value
                user_principal_name             = aad_user_value.formatted_user_principal_name
                password                        = aad_user_value.password
                expiration_date                 = aad_user_value.password_expiration
            }
        ]
    ])

    aad_users_secret_kv_locations_map = {
        aad_user_secret_kv_locations = {
        for aad_key, aad_value in local.aad_users_secret_kv_locations : format("%s_%s", aad_value.key, aad_value.kv) => aad_value
        }
    }

}

resource "azurerm_key_vault_secret" "aad_application_secret" {
  for_each = local.aad_application_secret_kv_locations_map.aad_application_secret_kv_locations

  name            = format("%s-AAD-secret", each.value.secret_display_name)
  value           = each.value.secret
  key_vault_id    = azurerm_key_vault.key_vault[each.value.kv].id
  content_type    = "AAD application secret"
  expiration_date = each.value.secret_expiration

}

resource "azurerm_key_vault_secret" "aad_user_password" {
  for_each = local.aad_users_secret_kv_locations_map.aad_user_secret_kv_locations

  name            = format("%s-AAD-user-password", each.value.user_principal_name)
  value           = each.value.password
  key_vault_id    = azurerm_key_vault.key_vault[each.value.kv].id
  content_type    = format("Username: %s@%s", each.value.key, each.value.domain_suffix)
  expiration_date = each.value.expiration_date
}

resource "azurerm_key_vault_secret" "ssh_keys" {
  for_each = data.terraform_remote_state.keys.outputs.ssh_keys

  name         = format("%s-ssh-private-key", each.value.user)
  value        = base64encode(file(format("..\\keys\\keys\\%s.pem", each.value.filename)))
  key_vault_id = azurerm_key_vault.key_vault[each.value.kv].id
  content_type = "SSH Private Key"

}

resource "azurerm_key_vault_secret" "public_ssh_key" {
  for_each = data.terraform_remote_state.keys.outputs.ssh_keys

  name         = format("%s-ssh-public-key", each.value.user)
  value        = base64encode(file(format("..\\keys\\keys\\%s.pub", each.value.filename)))
  key_vault_id = azurerm_key_vault.key_vault[each.value.kv].id
  content_type = "SSH Public Key"

}

resource "azurerm_key_vault_secret" "ssh_key_passphrase" {
  for_each = data.terraform_remote_state.keys.outputs.ssh_keys

  name         = format("%s-ssh-private-key-passphrase", each.value.user)
  value        = each.value.passphrase
  key_vault_id = azurerm_key_vault.key_vault[each.value.kv].id
  content_type = "SSH Private Key Passphrase"

}