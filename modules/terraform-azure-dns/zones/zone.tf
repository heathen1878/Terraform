resource "azurerm_dns_zone" "public" {
  for_each = var.zones

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  tags                = each.value.tags
}