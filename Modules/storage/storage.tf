resource "azurerm_storage_account" "storage_account" {
  for_each = data.terraform_remote_state.config.outputs.storage_accounts.accounts

  # Required
  name                     = each.value.name
  resource_group_name      = data.terraform_remote_state.resource_group.outputs.resource_group[each.value.resource_group_name].name
  location                 = data.terraform_remote_state.resource_group.outputs.resource_group[each.value.resource_group_name].location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type

  # Optional
  allow_nested_items_to_be_public = each.value.allow_nested_items_to_be_public

  tags = merge(var.tags)
}

resource "azurerm_storage_container" "storage_container" {
  for_each = data.terraform_remote_state.config.outputs.storage_accounts.containers

  name                  = each.value.container_name
  storage_account_name  = azurerm_storage_account.storage_account[each.value.account_key].name
  container_access_type = each.value.access_type
}