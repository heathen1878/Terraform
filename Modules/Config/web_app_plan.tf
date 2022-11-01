locals {

    windows_web_app_plan = {
        basic = {
            name = "basic"
            resource_group = "demo"
        }
    }

    windows_web_app_plan_output = {
        for windows_web_app_plan_key, windows_web_app_plan_value in local.windows_web_app_plan : windows_web_app_plan_key => {
            name     = azurecaf_name.windows_web_app_plan[windows_web_app_plan_key].result
            os_type  = "Windows"
            resource_group = lookup(local.windows_web_app_plan[windows_web_app_plan_key], "resource_group", "demo")
            sku_name = lookup(local.windows_web_app_plan[windows_web_app_plan_key], "sku_name", "B1")
        }
    }

}