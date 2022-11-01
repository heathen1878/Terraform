locals {

    windows_web_app = {
        demo = {
            name = "demo"
            resource_group = "demo"
        }
        #app_one = {
        #    name = "app_one"
        #    resource_group = "app_one"
        #}
        #app_two = {
        #    name = "app_two"
        #    app_plan = "standard"
        #    resource_group = "app_two"
        #}
    }

    windows_web_app_output = {
        for windows_web_app_key, windows_web_app_value in local.windows_web_app : windows_web_app_key => {
            app_plan = lookup(local.windows_web_app[windows_web_app_key], "app_plan", "basic")
            name = azurecaf_name.windows_web_app[windows_web_app_key].result
            resource_group = lookup(local.windows_web_app[windows_web_app_key], "resource_group", "demo")
        }
    }

}