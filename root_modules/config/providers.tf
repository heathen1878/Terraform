provider "azurerm" {
  features {
  }
}
provider "azurerm" {
  alias           = "mgmt"
  subscription_id = var.management_subscription
  features {
  }
}
provider "random" {
}
provider "azurecaf" {
}
provider "time" {
}
