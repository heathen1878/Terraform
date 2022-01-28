resource "azurecaf_name" "resourceGroup" {
    name = lower(random_id.subscriptionAndEnvironmentAndLocationUnique.id)
    resource_type = "azurerm_resource_group"
    suffixes = [ var.usage ]
}

resource "azurecaf_name" "nwResourceGroup" {
    name = lower(random_id.subscriptionAndLocationUnique.id)
    resource_type = "azurerm_resource_group"
}

resource "azurecaf_name" "keyVault" {
    name = lower(random_id.subscriptionAndEnvironmentAndLocationUnique.id)
    resource_type = "azurerm_key_vault"
    suffixes = [ var.usage ]
}

resource "azurecaf_name" "networkWatcher" {
    name = lower(random_id.subscriptionAndLocationUnique.id)
    resource_type = "azurerm_network_watcher"
}

resource "azurecaf_name" "virtualNetwork" {
    name = lower(random_id.resourceGroupUnique.id)
    resource_type = "azurerm_virtual_network"
    suffixes = ["hub"]
}

resource "azurecaf_name" "networkSecurityGroup" {
    name = lower(random_id.resourceGroupUnique.id)
    resource_type = "azurerm_network_security_group"
    suffixes = [ var.usage ]
}

resource "azurecaf_name" "availabilitySet" {
    name = lower(random_id.resourceGroupUnique.id)
    resource_type = "azurerm_availability_set"
    suffixes = [ var.usage ]
}

resource "azurecaf_name" "networkAdapter" {
    name = lower(random_id.resourceGroupUnique.id)
    resource_type = "azurerm_network_interface"
}

resource "azurecaf_name" "managedOSDisk" {    
    name = lower(random_id.resourceGroupUnique.id)
    resource_type = "azurerm_managed_disk"
    prefixes = [ "os" ]
}

resource "azurecaf_name" "managedDataDisk" {
    name = lower(random_id.resourceGroupUnique.id)
    resource_type = "azurerm_managed_disk"
    prefixes = [ "data" ]
}

resource "azurecaf_name" "virtualMachineLinux" {
    name = lower(random_id.resourceGroupUnique.id)
    resource_type = "azurerm_linux_virtual_machine"
}

resource "azurecaf_name" "virtualMachineWin" {
    name = lower(random_id.resourceGroupUnique.id)
    resource_type = "azurerm_windows_virtual_machine"
}

resource "azurecaf_name" "publicIPAddress" {
    name = lower(random_id.resourceGroupUnique.id)
    resource_type = "azurerm_public_ip"  
}


