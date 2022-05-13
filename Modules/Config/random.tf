resource "random_id" "key_vault" {
  for_each = local.key_vaults

  keepers = {
    environment  = each.value.env
    location     = each.value.location
    subscription = each.value.subscription
  }

  byte_length = 8

}

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

resource "random_id" "net_resource_group_unique" {
  keepers = {
    resourceGroup = azurecaf_name.net_resource_group.result
    environment = var.environment
    location = local.location
  }
  byte_length = 16
}

resource "random_id" "linux_virtual_machine" {
  for_each = local.virtual_machine

  keepers = {
    resourceGroup = azurecaf_name.vm_resource_group.result
    environment = var.environment
    location = local.location
  }
  byte_length = 16
}

resource "random_id" "windows_virtual_machine" {
    for_each = local.virtual_machine

    keepers = {
        environment = var.environment
        location = local.location
        subscription = data.azurerm_subscription.current.subscription_id
    }
    byte_length = 6
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

resource "random_password" "virtual_machine" {
  for_each = local.virtual_machine

  length = 24
  special = true
  min_lower = 1
  min_numeric = 1
  min_upper = 1

  keepers = {
  }

}

/*
NOTES
To maintain naming standards with virtual machines...underscores have been removed from other resources
*/
locals {
    key_vault                                                   = {
      for key_vault_key, key_vault_value in random_id.key_vault : key_vault_key => {
        name = replace(lower(key_vault_value.id), "/[^0-9a-zA-Z]/", "")
      }
    }
    linux_virtual_machine                                             = {
      for virtual_machine_key, virtual_machine_value in random_id.linux_virtual_machine : virtual_machine_key => {
        name = replace(lower(virtual_machine_value.id), "/[^0-9a-zA-Z]/", "")
      }
    }
    windows_virtual_machine                                             = {
      for virtual_machine_key, virtual_machine_value in random_id.windows_virtual_machine : virtual_machine_key => {
        name = replace(lower(virtual_machine_value.id), "/[^0-9a-zA-Z]/", "")
      }
    }
    subscriptionAndEnvironmentAndLocationUnique                 = replace(lower(random_id.subscriptionAndEnvironmentAndLocationUnique.id), "/[^0-9a-zA-Z]/", "")
    subscriptionAndEnvironmentAndLocationUnique_charlimitation  = replace(lower(random_id.subscriptionAndEnvironmentAndLocationUnique_charlimitation.id), "/[^0-9a-zA-Z]/", "")
    subscriptionAndLocationUnique                               = replace(lower(random_id.subscriptionAndLocationUnique.id), "/[^0-9a-zA-Z]/", "")
    netResourceGroupUnique                                      = replace(lower(random_id.net_resource_group_unique.id), "/[^0-9a-zA-Z]/", "")
    location                                                    = replace(lower(var.location), " ", "")
}


