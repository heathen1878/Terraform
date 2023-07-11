locals {

  container_registries = {
    #northeuropeacr = {
    #  admin_enabled = true
    #}
  }

  # ---------------------------------------------------------------------------------------------------------------------
  # LOCAL CALCULATED
  # ---------------------------------------------------------------------------------------------------------------------

  container_registry_output = {
    for acr_key, acr_value in local.container_registries : acr_key => {
      name                          = azurecaf_name.acr[acr_key].result
      resource_group                = lookup(acr_value, "resource_group", "environment")
      sku                           = lookup(acr_value, "sku", "Basic")
      admin_enabled                 = lookup(acr_value, "admin_enabled", false)
      anonymous_pull_enabled        = lookup(acr_value, "anonymous_pull_enabled", false)
      data_endpoint_enabled         = lookup(acr_value, "data_endpoint_enabled", false)
      export_policy_enabled         = lookup(acr_value, "export_policy_enabled", false)
      georeplications               = lookup(acr_value, "georeplications", {})
      network_rule_bypass_option    = lookup(acr_value, "network_rule_bypass_option", "AzureServices")
      network_rule_set              = lookup(acr_value, "network_rule_set", {})
      public_network_access_enabled = lookup(acr_value, "public_network_access_enabled", true)
      quarantine_policy_enabled     = lookup(acr_value, "quarantine_policy_enabled", false)
      trust_policy                  = lookup(acr_value, "trust_policy", false)
      retention_policy              = lookup(acr_value, "retention_policy", {})
      zone_redundancy_enabled       = lookup(acr_value, "zone_redundancy_enabled", false)
    }
  }

}