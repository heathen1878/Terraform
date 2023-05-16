variable "key_vaults" {
  description = "A map of key vaults"
  type = map(object(
    {
      name                            = string
      resource_group_name             = string
      location                        = string
      tenant_id                       = string
      sku_name                        = string
      tags                            = map(any)
      enabled_for_deployment          = optional(bool, false)
      enabled_for_disk_encryption     = optional(bool, false)
      enabled_for_template_deployment = optional(bool, false)
      enable_rbac_authorization       = optional(bool, false)
      network_acls = object(
        {
          bypass                     = optional(string, "None")
          default_action             = optional(string, "Allow")
          ip_rules                   = optional(list(string), [])
          virtual_network_subnet_ids = optional(list(string), [])
        }
      )
      purge_protection_enabled      = optional(bool, false)
      public_network_access_enabled = optional(bool, true)
      soft_delete_retention_days    = optional(number, 90)
    }
  ))

}