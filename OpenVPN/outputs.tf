output "resourceGroup_Id" {
  value = azurerm_resource_group.resourceGroup.id
}
output "networkWatcher_Id" {
  value = azurerm_network_watcher.networkWatcher.id
}
output "virtualNetwork_Id" {
  value = azurerm_virtual_network.hubvNet.id
}