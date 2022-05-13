resource "azurecaf_name" "kv_resource_group" {
    name = local.subscriptionAndEnvironmentAndLocationUnique
    resource_type = "azurerm_resource_group"
    suffixes = [
        var.namespace,
        "secrets"
    ]
}

resource "azurecaf_name" "key_vault" {
    for_each = local.key_vault

    name = each.value.name
    resource_type = "azurerm_key_vault"
    suffixes = [ var.namespace ]
}

resource "azurecaf_name" "net_resource_group" {
    name = local.subscriptionAndEnvironmentAndLocationUnique
    resource_type = "azurerm_resource_group"
    suffixes = [ 
        var.namespace,
        "network"
    ]
}

resource "azurecaf_name" "vm_resource_group" {
    name = local.subscriptionAndEnvironmentAndLocationUnique
    resource_type = "azurerm_resource_group"
    suffixes = [ 
        var.namespace,
        "vms"
    ]
}

resource "azurecaf_name" "virtual_network" {
    name = local.netResourceGroupUnique
    resource_type = "azurerm_virtual_network"
    suffixes = [ 
        var.namespace
    ]
}

resource "azurecaf_name" "linux_virtual_machine" {
    for_each = local.linux_virtual_machine

    name = each.value.name
    resource_type = "azurerm_linux_virtual_machine"
    suffixes = [
        var.namespace
    ]
}

resource "azurecaf_name" "windows_virtual_machine" {
    for_each = local.windows_virtual_machine

    name = each.value.name
    resource_type = "azurerm_windows_virtual_machine"
    suffixes = [
        var.namespace
    ]
}

resource "azurecaf_name" "network_security_group" {
    name = local.netResourceGroupUnique
    resource_type = "azurerm_network_security_group"
    suffixes = [
        var.namespace
    ]
}