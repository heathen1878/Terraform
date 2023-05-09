/* 
Known issue with this code - you cannot deploy these resources into the same subscription and location for 
multiple environments. This is because you can only have one Network Watcher per subscription per location. 
 */
resource "azurerm_network_watcher" "networkWatcher" {
    name = azurecaf_name.networkWatcher.result
    resource_group_name = azurerm_resource_group.resourceGroup.name
    location = var.location
    tags = var.tags
}

resource "azurerm_virtual_network" "hubvNet" {
    name = azurecaf_name.virtualNetwork.result
    resource_group_name = azurerm_resource_group.resourceGroup.name
    location = var.location
    address_space = var.hubvirtualNetwork.hub.addressSpace
    dns_servers = var.hubvirtualNetwork.hub.dnsServers !=null ? var.hubvirtualNetwork.hub.dnsServers : []
    depends_on = [
        azurerm_network_watcher.networkWatcher // created dependency to force network watcher to be created prior to the vNet being deployed.
    ]
    tags = var.tags
}

resource "azurerm_subnet" "hubvNet_subnets" {
    for_each = var.hubvirtualNetwork.hub.subnets
    name = each.key
    resource_group_name = azurerm_resource_group.resourceGroup.name
    virtual_network_name = azurerm_virtual_network.hubvNet.name
    address_prefixes = each.value
}