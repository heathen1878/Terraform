resource "azurerm_windows_web_app" "windows_web_app" {
    for_each = data.terraform_remote_state.config.outputs.windows_web_app

    name = each.value.name
    location = data.terraform_remote_state.resource_groups.outputs.resource_group[each.value.resource_group].location
    resource_group_name = data.terraform_remote_state.resource_groups.outputs.resource_group[each.value.resource_group].name
    service_plan_id = azurerm_service_plan.windows_web_app_plan[each.value.app_plan].id

    site_config {

        application_stack {
          current_stack = "dotnet"
          dotnet_version = "v4.0"
        }
      
    }

    tags = merge(var.tags, {
        location = var.location
        environment = var.environment
        }
    )

    #lifecycle {
    #  ignore_changes = [
    #    site_config[0].application_stack[0].dotnet_version
    #  ]
    #}    

}