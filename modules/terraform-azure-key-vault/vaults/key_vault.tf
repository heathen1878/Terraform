resource "azurerm_key_vault" "key_vault" {
  for_each = var.key_vaults

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  tenant_id           = each.value.tenant_id
  sku_name            = each.value.sku_name
  tags                = each.value.tags

  enabled_for_deployment          = each.value.enabled_for_deployment
  enabled_for_disk_encryption     = each.value.enabled_for_disk_encryption
  enabled_for_template_deployment = each.value.enabled_for_template_deployment
  enable_rbac_authorization       = each.value.enable_rbac_authorization

  dynamic "network_acls" {
    for_each = length(each.value.network_acls.ip_rules) != 0 || length(each.value.network_acls.virtual_network_subnet_ids) != 0 ? { "acls" = "enabled" } : {}

    content {
      bypass                     = network_acls.value.bypass
      default_action             = network_acls.value.default_action
      ip_rules                   = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }

  }

  purge_protection_enabled      = each.value.purge_protection_enabled
  public_network_access_enabled = each.value.public_network_access_enabled
  soft_delete_retention_days    = each.value.soft_delete_retention_days
}
