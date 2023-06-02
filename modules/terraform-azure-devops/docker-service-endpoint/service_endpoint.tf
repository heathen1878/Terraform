resource "azuredevops_serviceendpoint_dockerregistry" "acrs" {
  for_each = var.docker_service_endpoint

  project_id            = each.value.project_id
  description           = each.value.description
  service_endpoint_name = each.value.service_endpoint_name
  docker_registry       = each.value.docker_registry
  docker_username       = each.value.docker_username
  docker_password       = each.value.docker_password
  registry_type         = each.value.registry_type
}