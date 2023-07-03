##################### Subscription level resources ####################
# uses subscription Id and location to generate uniqueness
resource "random_id" "subscription_location_unique" {
  keepers = {
    location     = local.location
    subscription = data.azurerm_subscription.current.subscription_id
  }
  byte_length = 24
}

##################### Environment level resources #####################
# Unique resources globally with maximum 24 characters
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

resource "random_id" "windows_function_app" {
  for_each = local.windows_function_apps

  keepers = {
    key            = each.key
    environment    = var.environment
    location       = local.location
    resource_group = azurecaf_name.resource_group[each.value.resource_group].result
    subscription   = data.azurerm_subscription.current.subscription_id
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
  for_each = local.windows_web_apps

  keepers = {
    key            = each.key
    environment    = var.environment
    location       = local.location
    resource_group = azurecaf_name.resource_group[each.value.resource_group].result
    subscription   = data.azurerm_subscription.current.subscription_id
  }
  byte_length = 12

}
########################################################################

########################################################################
# Unique resources within a subscription
resource "random_id" "resource_group_unique" {
  for_each = local.resource_groups

  keepers = {
    resource_group = azurecaf_name.resource_group[each.key].result
  }
  byte_length = 16
}

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
########################################################################

########################################################################
# Unique resources within a resource group
resource "random_id" "acg" {
  for_each = local.container_groups

  keepers = {
    resource_group = azurecaf_name.resource_group[each.value.resource_group].result
  }
  byte_length = 6

}

resource "random_id" "nat_gateway" {
  for_each = local.nat_gateways

  keepers = {
    resource_group = azurecaf_name.resource_group[each.value.resource_group].result
  }
  byte_length = 12

}

resource "random_id" "network_watcher" {
  for_each = local.network_watchers

  keepers = {
    resource_group = azurecaf_name.resource_group[each.value.resource_group].result
  }
  byte_length = 12
}

resource "random_id" "public_ip_address" {
  for_each = local.public_ip_addresses

  keepers = {
    resource_group = azurecaf_name.resource_group[each.value.resource_group].result
  }
  byte_length = 12

}

resource "random_id" "route_table" {
  for_each = local.route_tables

  keepers = {
    resource_group = azurecaf_name.resource_group[each.value.resource_group].result
  }
  byte_length = 12

}

resource "random_id" "virtual_network" {
  for_each = local.virtual_networks

  keepers = {
    resource_group = azurecaf_name.resource_group[each.value.resource_group].result
  }
  byte_length = 12
}

resource "random_id" "dns_resolver" {
  for_each = local.dns_resolvers

  keepers = {
    resource_group = azurecaf_name.resource_group[each.value.resource_group].result
  }
  byte_length = 12
}

resource "random_id" "consumption_service_plans" {
  for_each = local.consumption_service_plans

  keepers = {
    key = each.key
  }
  byte_length = 16
}

resource "random_id" "virtual_machine" {
  for_each = local.virtual_machines

  keepers = {
    resource_group = azurecaf_name.resource_group[each.value.resource_group].result
  }
  byte_length = 6
}

resource "random_id" "premium_service_plans" {
  for_each = local.premium_service_plans

  keepers = {
    key = each.key
  }
  byte_length = 16
}

resource "random_id" "service_plans" {
  for_each = local.service_plans

  keepers = {
    key = each.key
  }
  byte_length = 16
}
########################################################################

########################################################################
# Uniqueness within AAD maximum 64 characters
resource "random_uuid" "aad_application" {
  for_each = local.aad_applications
}
########################################################################

########################################################################
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
  for_each = local.virtual_machines

  length      = 24
  special     = true
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1

  keepers = {
  }

}
########################################################################

/*
NOTES
Random outputs used for storage accounts, key vaults and virtual machines are set to lowercase and have special characters removed.
*/
locals {
  acg = {
    for acg_key, acg_value in random_id.acg : acg_key => {
      name = replace(lower(acg_value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  acr = {
    for acr_key, acr_value in random_id.acr : acr_key => {
      name = replace(lower(acr_value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  dns_resolver = {
    for key, value in random_id.dns_resolver : key => {
      name = replace(lower(value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  consumption_service_plan = {
    for key, value in random_id.consumption_service_plans : key => {
      name = replace(lower(value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  windows_function_app = {
    for key, value in random_id.windows_function_app : key => {
      name = replace(lower(value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  key_vault = {
    for key, value in random_id.key_vault : key => {
      name = replace(lower(value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  resource_group = {
    for key, value in random_id.subscription_location_namespace_environment_unique_rg : key => {
      name = replace(lower(value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  nat_gateway = {
    for key, value in random_id.nat_gateway : key => {
      name = replace(lower(value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  network_watcher = {
    for key, value in random_id.network_watcher : key => {
      name = replace(lower(value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  public_ip_address = {
    for key, value in random_id.public_ip_address : key => {
      name = replace(lower(value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  route_table = {
    for key, value in random_id.route_table : key => {
      name = replace(lower(value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  virtual_network = {
    for key, value in random_id.virtual_network : key => {
      name = replace(lower(value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  virtual_machine = {
    for key, value in random_id.virtual_machine : key => {
      name = replace(lower(value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  premium_service_plan = {
    for key, value in random_id.premium_service_plans : key => {
      name = replace(lower(value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  service_plan = {
    for key, value in random_id.service_plans : key => {
      name = replace(lower(value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  windows_web_app = {
    for windows_web_app_key, windows_web_app_value in random_id.windows_web_app : windows_web_app_key => {
      name = replace(lower(windows_web_app_value.id), "/[^0-9a-zA-Z]/", "")
    }
  }
  resource_group_unique = {
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
