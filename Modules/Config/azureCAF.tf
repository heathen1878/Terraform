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
    name = local.net_resource_group_unique
    resource_type = "azurerm_virtual_network"
    suffixes = [ 
        var.namespace
    ]
}

resource "azurecaf_name" "network_security_group" {
    name = local.net_resource_group_unique
    resource_type = "azurerm_network_security_group"
    suffixes = [
        var.namespace
    ]
}

resource "azurecaf_name" "public_ip_address" {
    for_each = {
        for virtual_machine_key, virtual_machine_value in local.virtual_machine : virtual_machine_key => virtual_machine_value
        if virtual_machine_value.public_ip_address == true
    }
    
    name = local.formatted_virtual_machine[each.key].name
    resource_type  = "azurerm_public_ip"
    suffixes = [
        var.namespace
    ]
}

resource "azurecaf_name" "availability_set" {
    for_each = local.formatted_virtual_machine

    name = each.value.name
    resource_type = "azurerm_availability_set"
    suffixes = [
        var.namespace
    ]
}

resource "azurecaf_name" "network_adapter" {
    for_each = local.formatted_virtual_machine

    name = each.value.name
    resource_type = "azurerm_network_interface"
    suffixes = [
        var.namespace
    ]
}

resource "azurecaf_name" "managed_os_disk" {
    for_each = local.formatted_virtual_machine

    name = each.value.name
    resource_type = "azurerm_managed_disk"
    suffixes = [
        var.namespace
    ]
}

resource "azurecaf_name" "linux_virtual_machine" {
    for_each = local.formatted_virtual_machine

    name = each.value.name
    resource_type = "azurerm_linux_virtual_machine"
    suffixes = [
        var.namespace
    ]
}

resource "azurecaf_name" "windows_virtual_machine" {
    for_each = local.formatted_virtual_machine

    name = each.value.name
    resource_type = "azurerm_windows_virtual_machine"
    suffixes = [
        var.namespace
    ]
}