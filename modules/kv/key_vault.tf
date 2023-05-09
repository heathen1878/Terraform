resource "azurerm_key_vault" "key_vault" {
  for_each = data.terraform_remote_state.config.outputs.key_vaults.vaults

  name                      = each.value.kv_name
  resource_group_name       = data.terraform_remote_state.resource_group.outputs.resource_group[each.value.resource_group_name].name
  location                  = data.terraform_remote_state.resource_group.outputs.resource_group[each.value.resource_group_name].location
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization = true
  sku_name                  = "standard"
  tags = merge(var.tags,
    {
      vault = each.key
    }
  )

}
