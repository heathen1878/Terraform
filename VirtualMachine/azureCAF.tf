/*
NOTES
To maintain naming standards with virtual machines...underscores have been removed from other resources
*/
locals {
    subscriptionAndEnvironmentAndLocationUnique = replace(lower(random_id.subscriptionAndEnvironmentAndLocationUnique.id), "/[^0-9a-zA-Z]/", "")
    subscriptionAndEnvironmentAndLocationUnique_charlimitation = replace(lower(random_id.subscriptionAndEnvironmentAndLocationUnique_charlimitation.id), "/[^0-9a-zA-Z]/", "")
    subscriptionAndLocationUnique = replace(lower(random_id.subscriptionAndLocationUnique.id), "/[^0-9a-zA-Z]/", "")
    resourceGroupUnique = replace(lower(random_id.resourceGroupUnique.id), "/[^0-9a-zA-Z]/", "")
    usage = lower(var.usage)
}

resource "azurecaf_name" "resourceGroup" {
    name = local.subscriptionAndEnvironmentAndLocationUnique
    resource_type = "azurerm_resource_group"
    suffixes = [ local.usage ]
}

resource "azurecaf_name" "nwResourceGroup" {
    name = local.subscriptionAndLocationUnique
    resource_type = "azurerm_resource_group"
}

resource "azurecaf_name" "keyVault" {
    name = local.subscriptionAndEnvironmentAndLocationUnique_charlimitation
    resource_type = "azurerm_key_vault"
    suffixes = [ local.usage ]
}

resource "azurecaf_name" "networkWatcher" {
    name = local.subscriptionAndLocationUnique
    resource_type = "azurerm_network_watcher"
}

resource "azurecaf_name" "virtualNetwork" {
    name = local.resourceGroupUnique
    resource_type = "azurerm_virtual_network"
    suffixes = ["hub"]
}

resource "azurecaf_name" "networkSecurityGroup" {
    name = local.resourceGroupUnique
    resource_type = "azurerm_network_security_group"
    suffixes = [ local.usage ]
}

resource "azurecaf_name" "availabilitySet" {
    name = local.resourceGroupUnique
    resource_type = "azurerm_availability_set"
    suffixes = [ local.usage ]
}

resource "azurecaf_name" "networkAdapter" {
    name = local.resourceGroupUnique
    resource_type = "azurerm_network_interface"
}

resource "azurecaf_name" "managedOSDisk" {    
    name = local.resourceGroupUnique
    resource_type = "azurerm_managed_disk"
    prefixes = [ "os" ]
}

resource "azurecaf_name" "managedDataDisk" {
    name = local.resourceGroupUnique
    resource_type = "azurerm_managed_disk"
    prefixes = [ "data" ]
}

resource "azurecaf_name" "virtualMachineLinux" {
    name = local.resourceGroupUnique
    resource_type = "azurerm_linux_virtual_machine"
    suffixes = [ "lin" ]
}

# resource types azurerm_windows_virtual_machine and azurerm_virtual_machine limit the 
# length to 15 characters but I'm setting the computer name using a map variable
resource "azurecaf_name" "virtualMachineWindows" {
    name = local.resourceGroupUnique
    resource_type = "azurerm_linux_virtual_machine"
    suffixes = [ "win" ]
}

resource "azurecaf_name" "publicIPAddress" {
    name = local.resourceGroupUnique
    resource_type = "azurerm_public_ip"  
}


