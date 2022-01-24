resource "random_id" "resourceGroup" {
    keepers = {
        environment = var.environment
        location = trimspace(var.location)
        subscription = var.subscriptionId
    }
    byte_length = 16
}