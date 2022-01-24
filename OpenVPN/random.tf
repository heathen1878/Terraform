resource "random_id" "resourceGroup" {
    keepers = {
        environment = var.environment
        location = trimspace( var.location )
        subscription = var.subscriptionId
    }
    byte_length = 16
}

resource "random_id" "networkWatcher" {
    keepers = {
        location = trimspace( var.location )
        subscription = var.subscriptionId
    }
    byte_length = 32
}

resource "random_id" "virtualNetwork" {
    keepers = {
        resourceGroup = azurerm_resource_group.resourceGroup.name
        usage = var.usage
    }
    byte_length = 32
}

resource "random_id" "availabilitySet" {
    keepers = {
        resourceGroup = azurerm_resource_group.resourceGroup.name
        usage = var.usage
    }
}

resource "random_id" "networkAdapter" {
    keepers = {
        resourceGroup = azurerm_resource_group.resourceGroup.name
        usage = var.usage
    }
}