locals {

  container_registries = {
    northeuropeacr = {
    }
    northeuropewesteuropeacr = {
      sku = "Premium"
      georeplications = {
        west_europe = {
          location                  = "west europe"
          regional_endpoint_enabled = true
          zone_redundancy_enabled   = true
          tags = {
            enabled  = "True"
            Location = "West Europe"
          }
        }
        uk_south = {
          location                  = "uk south"
          regional_endpoint_enabled = true
          zone_redundancy_enabled   = true
          tags = {
            enabled  = "True"
            Location = "UK South"
          }
        }
      }
      trust_policy = {
        enabled = true
      }
      retention_policy = {
        days    = 7
        enabled = true
      }
    }
  }

  # ---------------------------------------------------------------------------------------------------------------------
  # LOCAL CALCULATED
  # ---------------------------------------------------------------------------------------------------------------------

  container_registry_output = {
    for acr_key, acr_value in local.container_registries : acr_key => {
      name                       = azurecaf_name.acr[acr_key].result
      resource_group             = lookup(acr_value, "resource_group", "demo")
      sku                        = lookup(acr_value, "sku", "Basic")
      admin_enabled              = lookup(acr_value, "admin_enabled", false)
      anonymous_pull_enabled     = lookup(acr_value, "anonymous_pull_enabled", false)
      data_endpoint_enabled      = lookup(acr_value, "data_endpoint_enabled", false)
      georeplications            = lookup(acr_value, "georeplications", {})
      network_rule_bypass_option = lookup(acr_value, "network_rule_bypass_option", "AzureServices")
      network_rule_set           = lookup(acr_value, "network_rule_set", {})
      trust_policy               = lookup(acr_value, "trust_policy", {})
      retention_policy           = lookup(acr_value, "retention_policy", {})
    }
  }
  
}