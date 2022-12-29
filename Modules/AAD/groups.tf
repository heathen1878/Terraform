resource "azuread_group" "mgt-azdo-group" {
  for_each                = data.terraform_remote_state.config.outputs.aad_groups.azdo
  display_name            = each.value.name
  prevent_duplicate_names = true
  security_enabled        = true
  description             = each.value.description

  # sleep to allow MS Graph to update changes, it can be slow to be visible to dependent resources
  # Windows
  provisioner "local-exec" {
    command     = "Start-Sleep 180"
    interpreter = ["PowerShell", "-NoProfile", "-Command"]
  }

  # Linux
  #provisioner "local-exec" {
  #  command = "sleep 180"
  #}

  lifecycle {
    ignore_changes = [
      members # this is handled by the resource azuread_group_member
    ]
  }

}

resource "azuread_group" "mgt-kv-group" {
  for_each                = data.terraform_remote_state.config.outputs.aad_groups.kv
  display_name            = each.value.name
  prevent_duplicate_names = true
  security_enabled        = true
  description             = each.value.description

  # sleep to allow MS Graph to update changes, it can be slow to be visible to dependent resources
  provisioner "local-exec" {
    command     = "Start-Sleep 180"
    interpreter = ["PowerShell", "-NoProfile", "-Command"]
  }

  lifecycle {
    ignore_changes = [
      members # this is handled by the resource azuread_group_member
    ]
  }

}

locals {

  key_vault_group_output = {
    for key_vault_group_key, key_vault_group_value in azuread_group.mgt-kv-group : key_vault_group_key => {
      object_id = key_vault_group_value.object_id
    }
  }

}