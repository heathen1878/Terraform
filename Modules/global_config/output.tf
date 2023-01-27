output "aad_applications" {
  value     = local.aad_applications_output
  sensitive = true
}

output "aad_application_service_connections" {
  value     = local.aad_applications_service_connection_output
  sensitive = true
}
