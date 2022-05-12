resource "azuread_user" "mgt_aad_user" {
  for_each            = data.terraform_remote_state.config.outputs.aad_users
  
  user_principal_name = format("%s@%s", each.key, each.value.domain_suffix)
  given_name          = each.value.forename
  surname             = each.value.surname
  display_name        = format("%s %s", each.value.forename, each.value.surname)
  mail_nickname       = each.key
  job_title           = each.value.job_title
  password            = each.value.password
  account_enabled     = each.value.enabled

  # sleep to allow MS Graph to update changes, it can be slow to be visible to dependent resources
  provisioner "local-exec" {
    command = "Start-Sleep 180"
    interpreter = ["PowerShell", "-Command", "-NoProfile"]
  }

}