locals {

  container_groups = {
    #azdo_linux_self_hosted_agent_0 = {
    #  containers = {
    #    azdo_linux_agent_0 = {
    #      acr_image = "azdoagent"
    #      acr_tag   = "233"
    #      cpu       = 2
    #      memory    = 2
    #      name      = "azdolinuxagent0"
    #      environment_variables = {
    #        AZP_URL        = data.azurerm_key_vault_secret.azdo_service_url.value
    #        AZP_AGENT_NAME = "azdolinuxagent0"
    #        AZP_POOL       = "Platform"
    #      }
    #      secure_environment_variables = {
    #        AZP_TOKEN = data.azurerm_key_vault_secret.aci_pat_token.value
    #      }
    #    }
    #  }
    #  image_registry_credential_key = "northeuropeacr"
    #  ip_address_type               = "Private"
    #  resource_group                = "demo"
    #  restart_policy                = "OnFailure"
    #  subnet                        = "Containers"
    #  tags                          = { usage = "DevOpsAgent" }
    #}
    #azdo_linux_self_hosted_agent_1 = {
    #  containers = {
    #    azdo_linux_agent_1 = {
    #      acr_image = "azdoagent"
    #      acr_tag   = "233"
    #      cpu       = 2
    #      memory    = 2
    #      name      = "azdolinuxagent1"
    #      environment_variables = {
    #        AZP_URL        = data.azurerm_key_vault_secret.azdo_service_url.value
    #        AZP_AGENT_NAME = "azdolinuxagent1"
    #        AZP_POOL       = "Platform"
    #      }
    #      secure_environment_variables = {
    #        AZP_TOKEN = data.azurerm_key_vault_secret.aci_pat_token.value
    #      }
    #    }
    #  }
    #  image_registry_credential_key = "northeuropeacr"
    #  ip_address_type               = "Private"
    #  resource_group                = "demo"
    #  restart_policy                = "OnFailure"
    #  subnet                        = "Containers"
    #  tags                          = { usage = "DevOpsAgent" }
    #}
  }

  container_instances = {
    for container in flatten([
      for acg_key, acg_value in local.container_groups : [
        for aci_key, aci_value in acg_value.containers : {
          acg_key                      = acg_key
          aci_key                      = aci_key
          acr_image                    = lookup(aci_value, "acr_image", "mcr.microsoft.com/azuredocs/aci-helloworld")
          acr_tag                      = lookup(aci_value, "acr_tag", "latest")
          cpu                          = lookup(aci_value, "cpu", "0.5")
          memory                       = lookup(aci_value, "memory", "1.5")
          container_name               = lookup(aci_value, "name", "hello-world")
          environment_variables        = lookup(aci_value, "environment_variables", {})
          secure_environment_variables = lookup(aci_value, "secure_environment_variables", {})
        }
      ]
    ]) : format("%s_%s", container.acg_key, container.aci_key) => container
  }

  container_groups_output = {
    for key, value in local.container_groups : key => {
      name           = azurecaf_name.acg[key].result
      resource_group = value.resource_group
      containers = {
        for aci_key, aci_value in local.container_instances : aci_key => aci_value
        if aci_value.acg_key == key
      }
      dns_name_label                = lookup(value, "dns_name_label", null)
      dns_name_label_reuse_policy   = lookup(value, "dns_name_label_reuse_policy", null)
      ip_address_type               = lookup(value, "ip_address_type", "Public")
      image_registry_credential_key = lookup(value, "image_registry_credential_key", "mcr.microsoft.com")
      os_type                       = lookup(value, "os_type", "Linux")
      restart_policy                = lookup(value, "restart_policy", "OnFailure")
      subnet_id                     = lookup(value, "subnet", null)
      tags = merge(
        {
          namespace = var.namespace
          location  = var.location
        },
        lookup(value, "tags", {}),
        var.tags
      )
      zones = lookup(value, "zones", [])
    }
  }

}