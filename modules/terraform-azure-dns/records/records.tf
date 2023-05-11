resource "azurerm_dns_ns_record" "name_servers" {
    for_each = var.record

    name                = each.value.name
    zone_name           = each.value.zone_name
  resource_group_name = each.value.resource_group_name
  ttl                 = each.value.ttl

  records = each.value.records

  tags = each.value.tags
}