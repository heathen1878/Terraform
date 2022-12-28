### Subscription level resources ###
### uses subscription Id and location to generate uniqueness
resource "random_id" "subscription_location_unique" {
  keepers = {
    location     = local.location
    subscription = data.azurerm_subscription.current.subscription_id
  }
  byte_length = 24
}

### Environment level resources ###
############################################################################
# Unique resources globally with maximum 24 character
resource "random_id" "key_vault" {
  for_each = local.key_vaults

  keepers = {
    key          = each.key
    environment  = var.environment
    location     = local.location
    subscription = data.azurerm_subscription.current.subscription_id
  }
  byte_length = 12

}

resource "random_id" "acr" {
  for_each = local.container_registries

  keepers = {
    key          = each.key
    environment  = var.environment
    location     = local.location
    subscription = data.azurerm_subscription.current.subscription_id
  }
  byte_length = 12

}

resource "random_id" "storage_account" {
  for_each = local.storage

  keepers = {
    key          = each.key
    environment  = var.environment
    location     = local.location
    subscription = data.azurerm_subscription.current.subscription_id
  }
  byte_length = 12

}

resource "random_id" "windows_web_app" {
  for_each = local.windows_web_app

  keepers = {
    key           = each.key
    environment   = var.environment
    location      = local.location
    resourceGroup = azurecaf_name.resource_group[each.value.resource_group].result
    subscription  = data.azurerm_subscription.current.subscription_id
  }
  byte_length = 12

}

# Unique resources within a subscription
############################################################################
resource "random_id" "subscription_location_namespace_environment_unique" {

  keepers = {
    environment  = var.environment
    location     = local.location
    subscription = data.azurerm_subscription.current.subscription_id
    namespace    = var.namespace
  }
  byte_length = 24

}

resource "random_id" "subscription_location_namespace_environment_unique_rg" {
  for_each = local.resource_groups

  keepers = {
    key        = each.key
    uniqueness = local.subscription_location_namespace_environment_unique
  }
  byte_length = 24

}

# Unique resources within a resource group
############################################################################
resource "random_id" "resource_group_unique" {
  for_each = local.resource_groups

  keepers = {
    resourceGroup = azurecaf_name.resource_group[each.key].result
  }
  byte_length = 16
}

resource "random_id" "virtual_machine" {
  for_each = local.virtual_machine

  keepers = {
    resourceGroup = azurecaf_name.resource_group[each.value.resource_group].result
  }
  byte_length = 6
}

resource "random_id" "windows_web_app_plan" {
  for_each = local.windows_web_app_plan

  keepers = {
    resourceGroup = azurecaf_name.resource_group[each.value.resource_group].result
    plan_name     = each.value.name
  }
  byte_length = 16
}

############################################################################
# Uniqueness within AAD maximum 64 characters
resource "random_uuid" "aad_application" {
  for_each = local.aad_applications
}

############################################################################
# Passwords must be a minimum of 8 character and a maximum of 256 in length
resource "random_password" "aad_user" {
  for_each = local.aad_users

  length  = 24
  special = true

  keepers = {
    password_rotation = time_rotating.password_rotation[each.key].id
  }

}

resource "random_password" "virtual_machine" {
  for_each = local.virtual_machine

  length      = 24
  special     = true
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1

  keepers = {
  }

}

/*
NOTES
Random outputs used for storage accounts, key vaults and virtual machines are set to lowercase and have special characters removed.
*/
locals {
  acr = {
    for acr_key, acr_value in random_id.acr : acr_key => {
      name = replace(lower(acr_value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  key_vault = {
    for key_vault_key, key_vault_value in random_id.key_vault : key_vault_key => {
      name = replace(lower(key_vault_value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  resource_group = {
    for resource_group_key, resource_group_value in random_id.subscription_location_namespace_environment_unique_rg : resource_group_key => {
      name = replace(lower(resource_group_value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  formatted_virtual_machine = {
    for virtual_machine_key, virtual_machine_value in random_id.virtual_machine : virtual_machine_key => {
      name = replace(lower(virtual_machine_value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  formatted_windows_web_app_plan = {
    for windows_web_app_plan_key, windows_web_app_plan_value in random_id.windows_web_app_plan : windows_web_app_plan_key => {
      name = replace(lower(windows_web_app_plan_value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  formatted_windows_web_app = {
    for windows_web_app_key, windows_web_app_value in random_id.windows_web_app : windows_web_app_key => {
      name = replace(lower(windows_web_app_value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  formatted_resource_group_unique = {
    for resource_group_key, resource_group_value in random_id.resource_group_unique : resource_group_key => {
      name = replace(lower(resource_group_value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  storage_account = {
    for storage_account_key, storage_account_value in random_id.storage_account : storage_account_key => {
      name = replace(lower(storage_account_value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  subscription_location_namespace_environment_unique = replace(lower(random_id.subscription_location_namespace_environment_unique.id), "/[^0-9a-zA-Z]/", "")
  subscription_location_unique                       = replace(lower(random_id.subscription_location_unique.id), "/[^0-9a-zA-Z]/", "")
  location                                           = replace(lower(var.location), " ", "")
}

