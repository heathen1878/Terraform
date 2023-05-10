resource "azuread_user" "user" {
  for_each = var.users

  user_principal_name = each.value.user_principal_name
  given_name          = each.value.forename
  surname             = each.value.surname
  display_name        = each.value.display_name
  mail_nickname       = each.value.mail_nickname
  job_title           = each.value.job_title
  password            = each.value.password
  account_enabled     = each.value.enabled

  # sleep to allow MS Graph to update changes, it can be slow to be visible to dependent resources
  # Windows
  provisioner "local-exec" {
    command     = "Start-Sleep 180"
    interpreter = ["PowerShell", "-Command"]
  }

  # Linux
  #provisioner "local-exec" {
  #  command = "sleep 180"
  #}

}

locals {



}