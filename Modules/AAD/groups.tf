resource "azuread_group" "mgt-group" {
  for_each                = data.terraform_remote_state.config.outputs.aad_groups
  display_name            = each.value.name
  prevent_duplicate_names = true
  security_enabled        = true
  description             = each.value.description

  # sleep to allow MS Graph to update changes, it can be slow to be visible to dependent resources
  provisioner "local-exec" {
    command = "Start-Sleep 180"
    interpreter = ["PowerShell", "-Command", "-NoProfile"]
  }

  lifecycle {
    ignore_changes = [
      members # this is handled by the resource azuread_group_member
    ]
  }

}