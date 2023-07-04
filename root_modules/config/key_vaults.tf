locals {

  key_vaults = {
    frontend_secrets = {
      enable_private_endpoint = true
      iam = {
        readers = {
          role_definition_name = "Key Vault Reader"
          principal_id         = "bdde475c-f254-44b0-b48d-65ad83bffa4e"
        }
      }
      network_acls = {
        bypass = "AzureServices"
      }
      resource_group = "frontend"
      tags = {
        usage = "Secrets"
      }
    }
    backend_secrets = {
      enable_private_endpoint       = true
      network_acls                  = {}
      public_network_access_enabled = false
      resource_group                = "backend"
      tags = {
        usage = "Secrets"
      }
    }
    frontend_certificates = {
      enable_private_endpoint = true
      iam = {
        readers = {
          role_definition_name = "Key Vault Reader"
          principal_id         = "bdde475c-f254-44b0-b48d-65ad83bffa4e"
        }
      }
      network_acls   = {}
      resource_group = "frontend"
      tags = {
        usage = "Certificates"
      }
    }
    backend_certificates = {
      enable_private_endpoint       = true
      network_acls                  = {}
      public_network_access_enabled = false
      resource_group                = "backend"
      tags = {
        usage = "Certificates"
      }
    }
  }

  # ---------------------------------------------------------------------------------------------------------------------
  # LOCAL CALCULATED
  # ---------------------------------------------------------------------------------------------------------------------

  key_vault_output = {
    for key, value in local.key_vaults : key => {
      name                      = azurecaf_name.key_vault[key].result
      location                  = local.location
      resource_group            = lookup(value, "resource_group", "global")
      enable_private_endpoint   = lookup(value, "enable_private_endpoint", false)
      enable_rbac_authorization = lookup(value, "enable_rbac_authorization", true)
      iam                       = lookup(value, "iam", {})
      network_acls = {
        bypass                     = lookup(value.network_acls, "bypass", "None")
        default_action             = lookup(value.network_acls, "default_action", "Deny")
        ip_rules                   = lookup(value.network_acls, "ip_rules", [])
        virtual_network_subnet_ids = lookup(value.network_acls, "virtual_network_subnet_ids", [])
      }
      public_network_access_enabled = lookup(value, "public_network_access_enabled", true)
      sku_name                      = lookup(value, "sku_name", "standard")
      soft_delete_retention_days    = lookup(value, "soft_delete_retention_days", 7)
      tags = merge(
        {
          environment = var.environment
          namespace   = var.namespace
          location    = var.location
        },
        lookup(value, "tags", {}),
        var.tags
      )
      tenant_id                                   = var.tenant_id
      virtual_network_subnet_private_endpoint_key = "key_vault"
    }
  }

}