resource "random_id" "subscriptionAndEnvironmentAndLocationUnique" {
    keepers = {
        environment = var.environment
        location = trimspace( var.location )
        subscription = var.subscriptionId
    }
    byte_length = 16
}

resource "random_id" "subscriptionAndEnvironmentAndLocationUnique_charlimitation" {
    keepers = {
        environment = var.environment
        location = trimspace( var.location )
        subscription = var.subscriptionId
    }
    byte_length = 8
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
        resourceGroup = azurecaf_name.resourceGroup.result
        environment = var.environment
        location = trimspace( var.location )
    }
    byte_length = 16
}

