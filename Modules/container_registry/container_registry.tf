resource "azurerm_container_registry" "acr" {
  for_each = data.terraform_remote_state.config.outputs.container_registries

  name                = each.value.name
  resource_group_name = data.terraform_remote_state.resource_group.outputs.resource_group[each.value.resource_group].name
  location            = data.terraform_remote_state.resource_group.outputs.resource_group[each.value.resource_group].location
  sku                 = each.value.sku

  tags = merge(var.tags, {
    location    = var.location
    environment = var.environment
    namespace   = var.namespace
  })

  admin_enabled          = each.value.admin_enabled
  anonymous_pull_enabled = each.value.sku != "Basic" ? each.value.anonymous_pull_enabled : null

  data_endpoint_enabled = each.value.sku == "Premium" ? each.value.data_endpoint_enabled : null

  dynamic "georeplications" {
    for_each = {
      for georeplications_key, georeplications_value in each.value.georeplications : georeplications_key => georeplications_value
      if each.value.sku == "Premium"
    }

    content {
      location                  = georeplications.value.location
      regional_endpoint_enabled = georeplications.value.regional_endpoint_enabled
      zone_redundancy_enabled   = georeplications.value.zone_redundancy_enabled
      tags                      = georeplications.value.tags
    }

  }

  network_rule_bypass_option = each.value.network_rule_bypass_option # None or AzureServices

  dynamic "network_rule_set" {
    for_each = {
      for network_rule_set_key, network_rule_set_value in each.value.network_rule_set : network_rule_set_key => network_rule_set_value
      if each.value.sku == "Premium"
    }

    content {
      default_action = network_rule_set.value.default_action
      ip_rule {
        action   = "Allow"
        ip_range = network_rule_set.value.ip_range
      }
      virtual_network {
        action    = "Allow"
        subnet_id = network_rule_set.value.subnet_id
      }
    }


  }

  public_network_access_enabled = each.value.public_network_access_enabled
  quarantine_policy_enabled     = each.value.sku == "Premium" ? each.value.quarantine_policy_enabled : null

  dynamic "retention_policy" {
    for_each = {
      for retention_policy_key, retention_policy_value in each.value.retention_policy : retention_policy_key => retention_policy_value
      if each.value.sku == "Premium"
    }

    content {
      days    = 7
      enabled = retention_policy.value.enabled # premium only
    }
  }

  trust_policy {
    enabled = each.value.sku == "Premium" ? each.value.trust_policy : null # premium only
  }
  zone_redundancy_enabled = each.value.sku == "Premium" ? each.value.zone_redundancy_enabled : null # premium only
  export_policy_enabled   = each.value.sku == "Premium" ? each.value.export_policy_enabled : null   # premium only

  identity {
    type = "SystemAssigned"
  }

}

locals {

  container_registry_output = {
    for container_reg_key, container_reg_value in azurerm_container_registry.acr : container_reg_key => {
      name           = container_reg_value.name
      acr_url        = container_reg_value.login_server
      admin_username = container_reg_value.admin_username
      admin_password = container_reg_value.admin_password
    }
  }

  container_registry_dockerhub_azdo_connection = {
    for dockerhub in flatten([
      for azdo_project_key, azdo_project_value in data.terraform_remote_state.config.outputs.azdo_projects : [
        for azdo_dockerhub in azdo_project_value.dockerhub : {
          project_key           = azdo_project_key
          description           = format("Azure DevOps ACR docker hub service endpoint for %s", azurerm_container_registry.acr[azdo_dockerhub].name)
          service_endpoint_name = azurerm_container_registry.acr[azdo_dockerhub].name
          docker_registry       = azurerm_container_registry.acr[azdo_dockerhub].login_server
          docker_username       = data.terraform_remote_state.aad.outputs.aad_applications["docker_build"].object_id
          docker_password       = data.terraform_remote_state.aad.outputs.aad_applications["docker_build"].secret
        }
      ]
    ]) : format("%s_%s", dockerhub.project_key, dockerhub.service_endpoint_name) => dockerhub
  }

}