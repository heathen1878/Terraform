resource "random_id" "subscriptionAndEnvironmentAndLocationUnique" {
    keepers = {
        environment = var.environment
        location = trimspace( var.location )
        subscription = var.subscriptionId
    }
    byte_length = 16
}

resource "random_id" "subscriptionAndLocationUnique" {
    keepers = {
        location = trimspace( var.location )
        subscription = var.subscriptionId
    }
    byte_length = 16
}

resource "random_id" "resourceGroupUnique" {
    keepers = {
        resourceGroup = azurerm_resource_group.resourceGroup.name
        environment = var.environment
        usage = var.usage
    }
    byte_length = 16
}