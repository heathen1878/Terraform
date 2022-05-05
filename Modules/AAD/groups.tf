resource "azuread_group" "mgt-group" {
  for_each                = local.aad_groups
  display_name            = each.key
  prevent_duplicate_names = true
  security_enabled        = true
  description             = each.value.description

  # sleep to allow MS Graph to update changes, it can be slow to be visible to dependent resources
  provisioner "local-exec" {
    command = "Start-Sleep 180"
    interpreter = ["PowerShell", "-Command"]
  }

}