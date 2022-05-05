output "aad_applications" {
  value = local.aad_applications_output
}

output "aad_users" {
  value    = local.aad_users_output
  sensitive = true
}