locals {

  key_vaults = {
    secrets = {

    }
    certificates = {

    }
  }

  # ---------------------------------------------------------------------------------------------------------------------
  # LOCAL CALCULATED
  # ---------------------------------------------------------------------------------------------------------------------

  key_vault_output = {
    for key, value in local.key_vaults : key => {
      name           = azurecaf_name.key_vault[key].result
      resource_group = lookup(value, "resource_group", "demo")
      tenant_id      = var.tenant_id
      network_acls = {
        bypass                     = lookup(value, "network_acls.bypass", "None")
        default_action             = lookup(value, "network_acls.default_action", "Deny")
        ip_rules                   = lookup(value, "network_acls.ip_rules", [])
        virtual_network_subnet_ids = lookup(value, "network_acls.virtual_network_subnet_ids", [])
      }
      enable_rbac_authorization = lookup(value, "enable_rbac_authorization", true)
      sku_name                  = lookup(value, "sku_name", "standard")
      tags = merge(
        var.tags,
        lookup(value, "tags", {
          environment = var.environment
          namespace   = var.namespace
          usage       = key
        })
      )
    }
  }

}