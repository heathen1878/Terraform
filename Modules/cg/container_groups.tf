resource "azurerm_container_group" "acg" {
  for_each = data.terraform_remote_state.config.outputs.container_groups

  name                = each.value.name
  resource_group_name = data.terraform_remote_state.resource_group.outputs.resource_group[each.value.resource_group].name
  location            = data.terraform_remote_state.resource_group.outputs.resource_group[each.value.resource_group].location
  os_type             = each.value.os_type
  tags = merge(var.tags, {
    location    = var.location
    environment = var.environment
    namespace   = var.namespace
  })

  dynamic "container" {
    for_each = each.value.containers

    content {
      name   = container.value.container_name
      image  = container.value.acr_image != "mcr.microsoft.com/azuredocs/aci-helloworld" ? format("%s/%s", data.terraform_remote_state.acr.outputs.acr[each.value.image_registry_credential_key].acr_url, container.value.acr_image) : "mcr.microsoft.com/azuredocs/aci-helloworld"
      cpu    = container.value.cpu
      memory = container.value.memory
      gpu {}
      ports {
        port     = 80
        protocol = "TCP"
      }
      environment_variables        = container.value.environment_variables
      secure_environment_variables = container.value.secure_environment_variables
    }

  }

  # Optional
  dns_name_label              = each.value.dns_name_label
  dns_name_label_reuse_policy = each.value.dns_name_label_reuse_policy

  identity {
    type = "SystemAssigned"
  }

  image_registry_credential {
    username = try(data.terraform_remote_state.acr.outputs.acr[each.value.image_registry_credential_key].admin_username, each.value.image_registry_credential_key)
    password = try(data.terraform_remote_state.acr.outputs.acr[each.value.image_registry_credential_key].admin_password, each.value.image_registry_credential_key)
    server   = try(data.terraform_remote_state.acr.outputs.acr[each.value.image_registry_credential_key].acr_url, each.value.image_registry_credential_key)
  }

  ip_address_type = each.value.ip_address_type

  restart_policy = each.value.restart_policy

  subnet_ids = each.value.subnet_id

  zones = each.value.zones

}

locals {}