resource "random_id" "subscriptionAndEnvironmentAndLocationUnique" {
    keepers = {
        environment = var.environment
        location = trimspace( var.location )
        subscription = data.azurerm_client_config.current.subscription_id
    }
    byte_length = 16
}

resource "random_password" "ssh_keys" {
    for_each = local.aad_users_generate_ssh_keys_map

    length  = 24
    special = true

}