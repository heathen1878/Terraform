resource "azurecaf_name" "consumption_service_plan" {
  for_each = local.consumption_service_plan

  name          = each.value.name
  resource_type = "azurerm_app_service_plan"
}

resource "azurecaf_name" "resource_group" {
  for_each = local.resource_group

  name          = lower(each.value.name)
  resource_type = "azurerm_resource_group"
}

resource "azurecaf_name" "key_vault" {
  for_each = local.key_vault

  name          = each.value.name
  resource_type = "azurerm_key_vault"
}

resource "azurecaf_name" "acg" {
  for_each = local.acg

  name          = each.value.name
  resource_type = "azurerm_containerGroups"

}

resource "azurecaf_name" "acr" {
  for_each = local.acr

  name          = each.value.name
  resource_type = "azurerm_container_registry"
}

resource "azurecaf_name" "storage_account" {
  for_each = local.storage_account

  name          = each.value.name
  resource_type = "azurerm_storage_account"
}

resource "azurecaf_name" "network_security_group" {
  for_each = local.virtual_network_subnets

  name          = each.key
  resource_type = "azurerm_network_security_group"
}

resource "azurecaf_name" "public_ip_address" {
  for_each = local.public_ip_address

  name          = each.value.name
  resource_type = "azurerm_public_ip"
}

resource "azurecaf_name" "availability_set" {
  for_each = local.virtual_machine

  name          = each.value.name
  resource_type = "azurerm_availability_set"
}

resource "azurecaf_name" "network_adapter" {
  for_each = local.virtual_machine

  name          = each.value.name
  resource_type = "azurerm_network_interface"
}

resource "azurecaf_name" "managed_os_disk" {
  for_each = local.virtual_machine

  name          = each.value.name
  resource_type = "azurerm_managed_disk"
}

resource "azurecaf_name" "linux_virtual_machine" {
  for_each = local.virtual_machine

  name          = each.value.name
  resource_type = "azurerm_linux_virtual_machine"
}

resource "azurecaf_name" "windows_virtual_machine" {
  for_each = local.virtual_machine

  name          = each.value.name
  resource_type = "azurerm_windows_virtual_machine"
}

resource "azurecaf_name" "premium_service_plan" {
  for_each = local.premium_service_plan

  name          = each.value.name
  resource_type = "azurerm_app_service_plan"
}

resource "azurecaf_name" "service_plan" {
  for_each = local.service_plan

  name          = each.value.name
  resource_type = "azurerm_app_service_plan"
}

resource "azurecaf_name" "windows_function_app" {
  for_each = local.windows_function_app

  name          = each.value.name
  resource_type = "general"
  use_slug      = false
}

resource "azurecaf_name" "windows_function_app_storage" {
  for_each = local.windows_function_app

  name          = each.value.name
  resource_type = "azurerm_storage_account"
}

resource "azurecaf_name" "windows_web_app" {
  for_each = local.windows_web_app

  name          = each.value.name
  resource_type = "azurerm_app_service"
}

resource "azurecaf_name" "network_watcher" {
  for_each = local.network_watcher

  name          = each.value.name
  resource_type = "azurerm_network_watcher"
}

resource "azurecaf_name" "virtual_network" {
  for_each = local.virtual_network

  name          = each.value.name
  resource_type = "azurerm_virtual_network"
}

resource "azurecaf_name" "dns_resolver" {
  for_each = local.dns_resolver

  name          = each.value.name
  resource_type = "general"
  use_slug      = false
}

resource "azurecaf_name" "route_table" {
  for_each = local.route_table

  name          = each.value.name
  resource_type = "general"
}

resource "azurecaf_name" "nat_gateway" {
  for_each = local.nat_gateway

  name          = each.value.name
  resource_type = "general"
}