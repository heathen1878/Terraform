output "key_vault_groups" {
  value = local.key_vault_group_output
}

output "aad_applications" {
  value     = local.aad_applications_output
  sensitive = true
}

output "aad_users" {
  value = "AAD_USER_ATTRIBUTES"
}
