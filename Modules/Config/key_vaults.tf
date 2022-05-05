locals {

    key_vaults = {
        management = {
            env = var.environment
            location = trimspace(var.location)
            subscription = data.azurerm_subscription.current.subscription_id
        }
        certificates = {
            env = var.environment
            location = trimspace(var.location)
            subscription = data.azurerm_subscription.current.subscription_id
        }
    }

    key_vault_outputs = {
        for kv_key, kv_value in azurecaf_name.key_vault : kv_key => {
            kv_name = kv_value.result
        }
    }

}

resource "random_id" "key_vault" {
    for_each = local.key_vaults

    keepers = {
        usage         = each.key
        environment   = each.value.env
        location      = each.value.location
        subscription  = each.value.subscription
    }
    byte_length = 8
}

resource "azurecaf_name" "key_vault" {
    for_each = random_id.key_vault

    name = lower(each.value.id)
    resource_type = "azurerm_key_vault"
}