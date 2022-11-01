resource "azurerm_service_plan" "windows_web_app_plan" {
    for_each = data.terraform_remote_state.config.outputs.windows_web_app_plans

    name = each.value.name
    location = data.terraform_remote_state.resource_groups.outputs.resource_group[each.value.resource_group].location
    os_type = each.value.os_type
    resource_group_name = data.terraform_remote_state.resource_groups.outputs.resource_group[each.value.resource_group].name
    sku_name = each.value.sku_name
    tags = merge(var.tags, {
        location = var.location
        environment = var.environment
        }
    )
    
}