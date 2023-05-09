output "acr" {
  value     = local.container_registry_output
  sensitive = true
}

output "acr_dockerhub" {
  value     = local.container_registry_dockerhub_azdo_connection
  sensitive = true
}