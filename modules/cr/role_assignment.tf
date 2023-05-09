resource "azurerm_role_assignment" "docker_acr_push" {
  for_each = azurerm_container_registry.acr

  scope                = each.value.id
  role_definition_name = "AcrPush"
  principal_id         = data.terraform_remote_state.aad.outputs.aad_applications["docker_build"].service_principal_id

}