resource "random_id" "subscriptionAndEnvironmentAndLocationUnique" {
    keepers = {
        environment = var.environment
        location = trimspace( var.location )
        subscription = data.azurerm_client_config.current.subscription_id
    }
    byte_length = 16
}

resource "random_id" "subscriptionAndLocationUnique" {
    keepers = {
        location = trimspace( var.location )
        subscription = data.azurerm_client_config.current.subscription_id
    }
    byte_length = 16
}

resource "random_id" "resourceGroupUnique" {
    keepers = {
        resourceGroup = azurerm_resource_group.resourceGroup.name
        environment = var.environment
        location = trimspace( var.location )
    }
    byte_length = 16
}

resource "random_password" "ssh_keys" {
    for_each = {
        for aad_user_key, aad_user_value in data.terraform_remote_state.mgt-aad.outputs.aad_users : aad_user_key =>
        if aad_user_value.generate_ssh_keys = true
    }

    length  = 24
    special = true

}