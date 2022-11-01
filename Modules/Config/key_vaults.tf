locals {

    key_vaults = {
        management = {
            env = var.environment
            location = trimspace(var.location)
            subscription = data.azurerm_subscription.current.subscription_id
        }
    }

    key_vault_output = {
        vaults = {
            for kv_key, kv_value in azurecaf_name.key_vault : kv_key => {
                kv_name             = kv_value.result
                resource_group_name = azurecaf_name.resource_group["demo"].result
            }
        }
    }

}