locals {

  container_groups = {
    azdo_linux_self_hosted_agent = {
      containers = merge(try(var.container_groups.linux, {}), {
        azdo_linux_agent_0 = {
          acr       = "northeuropeacr"
          acr_image = "azdoagent"
          name      = "azdolinuxagent0"
          environment_variables = {
            AZP_URL        = data.azurerm_key_vault_secret.azdo_service_url.value
            AZP_AGENT_NAME = "azdolinuxagent0"
            AZP_POOL       = "Platform"
          }
          secure_environment_variables = {
            AZP_TOKEN = data.azurerm_key_vault_secret.aci_pat_token.value
          }
        }
        }
      )
      resource_group = "demo"
      restart_policy = "Always"
    }
    demo_container = {
      containers = merge(try(var.container_groups.demo, {}), {
        demo_container = {}
        }
      )
      resource_group = "demo"
    }
    #azdo_windows_self_hosted_agent = {
    #  containers = merge(try(var.container_groups.windows, {}), {
    #    azdo_windows_agent = {
    #      acr                          = ""
    #      acr_image                    = ""
    #      name                         = ""
    #      environment_variables        = ""
    #      secure_environment_variables = ""
    #    }
    #    }
    #  )
    #  os_type        = "Windows"
    #  resource_group = "demo"
    #  zones = [
    #    "1", "2", "3"
    #  ]
    #}
  }

  container_instances = {
    for container in flatten([
      for acg_key, acg_value in local.container_groups : [
        for aci_key, aci_value in acg_value.containers : {
          acg_key                      = acg_key
          aci_key                      = aci_key
          acr                          = lookup(aci_value, "acr", "mcr.microsoft.com")
          acr_image                    = lookup(aci_value, "acr_image", "/azuredocs/aci-helloworld")
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
    for acg_key, acg_value in local.container_groups : acg_key => {
      name           = azurecaf_name.acg[acg_key].result
      resource_group = acg_value.resource_group
      containers = {
        for aci_key, aci_value in local.container_instances : aci_key => aci_value
        if aci_value.acg_key == acg_key
      }
      dns_name_label              = lookup(acg_value, "dns_name_label", null)
      dns_name_label_reuse_policy = lookup(acg_value, "dns_name_label_reuse_policy", null)
      ip_address_type             = lookup(acg_value, "ip_address_type", "Public")
      image_registry_credential   = lookup(acg_value, "image_registry_credential", {})
      os_type                     = lookup(acg_value, "os_type", "Linux")
      subnet_id                   = lookup(acg_value, "subnet", null)
      restart_policy              = lookup(acg_value, "restart_policy", "OnFailure")
      zones                       = lookup(acg_value, "zones", [])
    }
  }

}