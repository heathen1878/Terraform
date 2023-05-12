resource "azurerm_app_service_custom_hostname_binding" "custom_domain" {
    for_each = var.custom_domains

    hostname = each.value.hostname
    app_service_name = each.value.app_service_name
    resource_group_name = each.value.resource_group_name
    ssl_state = each.value.ssl_state
    thumbprint = each.value.thumbprint
}