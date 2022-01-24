resource "azurerm_network_watcher" "networkWatcher" {
    name = azurecaf_name.networkWatcher.result
    location = var.location
    resource_group_name = azurerm_resource_group.resourceGroup.name
    tags = var.tags
}

resource "azurerm_virtual_network" "hubvNet" {
    name = azurecaf_name.virtualNetwork.result
    resource_group_name = azurerm_resource_group.resourceGroup.name
    location = var.location
    address_space = var.hubvirtualNetwork.hub.addressSpace
    dns_servers = var.hubvirtualNetwork.hub.dnsServers !=null ? var.hubvirtualNetwork.hub.dnsServers : []
    depends_on = [
        azurerm_resource_group.resourceGroup
    ]
    tags = var.tags
}

resource "azurerm_subnet" "hubvNet_subnets" {
    for_each = var.hubvirtualNetwork.hub.subnets
    name = each.key
    resource_group_name = azurerm_resource_group.resourceGroup.name
    virtual_network_name = azurerm_virtual_network.hubvNet.name
    address_prefixes = each.value
    depends_on = [
        azurerm_virtual_network.hubvNet
    ]
}