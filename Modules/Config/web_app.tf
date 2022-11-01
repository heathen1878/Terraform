locals {

    windows_web_app = {
        demo = {
            name = "demo"
            resource_group = "demo"
        }
    }

    windows_web_app_output = {
        for windows_web_app_key, windows_web_app_value in local.windows_web_app : windows_web_app_key => {
            application_stack = {
                current_stack  = lookup(local.windows_web_app[windows_web_app_key], "current_stack", "dotnet")
                dotnet_version = lookup(local.windows_web_app[windows_web_app_key], "dotnet_version", "v4.0")
            }
            app_plan = lookup(local.windows_web_app[windows_web_app_key], "app_plan", "basic")
            name = azurecaf_name.windows_web_app[windows_web_app_key].result
            resource_group = lookup(local.windows_web_app[windows_web_app_key], "resource_group", "demo")
        }
    }

}