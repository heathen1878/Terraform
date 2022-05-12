resource "random_id" "subscriptionAndLocationUnique" {
    keepers = {
        location = local.location
        subscription = data.azurerm_subscription.current.subscription_id
    }
    byte_length = 16
}

locals {
    subscriptionAndLocationUnique = replace(lower(random_id.subscriptionAndLocationUnique.id), "/[^0-9a-zA-Z]/", "")
    location = replace(lower(var.location), " ", "")
}