locals {

  key_vaults = {
    management = {
      resource_group = "management"
    }
    secrets = {

    }
    certificates = {

    }
  }

  # ---------------------------------------------------------------------------------------------------------------------
  # LOCAL CALCULATED
  # ---------------------------------------------------------------------------------------------------------------------

  key_vault_output = {
    vaults = {
      for kv_key, kv_value in local.key_vaults : kv_key => {
        kv_name                   = azurecaf_name.key_vault[kv_key].result
        resource_group_name       = lookup(kv_value, "resource_group", "demo")
        enable_rbac_authorization = lookup(kv_value, "enable_rbac_authorization", true)
        sku_name                  = lookup(kv_value, "sku_name", "standard")
      }
    }
  }

}