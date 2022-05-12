resource "random_id" "subscriptionAndEnvironmentAndLocationUnique" {

    keepers = {
        environment = var.environment
        location = local.location
        subscription = data.azurerm_subscription.current.subscription_id
    }
    byte_length = 16
}

resource "random_id" "subscriptionAndEnvironmentAndLocationUnique_charlimitation" {
    keepers = {
        environment = var.environment
        location = local.location
        subscription = data.azurerm_subscription.current.subscription_id
    }
    byte_length = 8
}

resource "random_id" "subscriptionAndLocationUnique" {
    keepers = {
        location = local.location
        subscription = data.azurerm_subscription.current.subscription_id
    }
    byte_length = 16
}

resource "random_id" "resourceGroupUnique" {
    keepers = {
        resourceGroup = azurecaf_name.resource_group.result
        environment = var.environment
        location = local.location
    }
    byte_length = 16
}

resource "random_uuid" "aad_application" {
  for_each = local.aad_applications
}

resource "random_password" "aad_user" {
  for_each = local.aad_users

  length = 24
  special = true

  keepers = {
    password_rotation = time_rotating.password_rotation[each.key].id
  }

}

resource "random_password" "aad_application" {
  for_each = local.aad_applications

  length = 24
  special = true

  keepers = {
    password_rotation = time_rotating.secret_rotation[each.key].id
  }

}

/*
NOTES
To maintain naming standards with virtual machines...underscores have been removed from other resources
*/
locals {
    subscriptionAndEnvironmentAndLocationUnique = replace(lower(random_id.subscriptionAndEnvironmentAndLocationUnique.id), "/[^0-9a-zA-Z]/", "")
    subscriptionAndEnvironmentAndLocationUnique_charlimitation = replace(lower(random_id.subscriptionAndEnvironmentAndLocationUnique_charlimitation.id), "/[^0-9a-zA-Z]/", "")
    subscriptionAndLocationUnique = replace(lower(random_id.subscriptionAndLocationUnique.id), "/[^0-9a-zA-Z]/", "")
    resourceGroupUnique = replace(lower(random_id.resourceGroupUnique.id), "/[^0-9a-zA-Z]/", "")
    location = replace(lower(var.location), " ", "")
}


