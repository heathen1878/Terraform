resource "azuread_user" "mgt_aad_user" {
  for_each            = local.aad_users
  user_principal_name = format("%s@%s", each.key, each.value.domain_suffix)
  given_name          = each.value.forename
  surname             = each.value.surname
  display_name        = format("%s %s", each.value.forename, each.value.surname)
  mail_nickname       = each.key
  job_title           = each.value.job_title
  password            = random_password.aad_user[each.key].result
  account_enabled     = each.value.enabled
}