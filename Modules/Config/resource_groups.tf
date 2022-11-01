locals {

    resource_groups = {
        demo = {
            name = "demo"
        }
        #app_one = {
        #    name = "app_one"
        #}
        #app_two = {
        #    name = "app_two"
        #}
    }

    resource_groups_outputs = {
        for resource_group_key, resource_group_value in local.resource_groups : resource_group_key => {
            name = azurecaf_name.resource_group[resource_group_key].result
        }
    }

}