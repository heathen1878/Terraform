provider "azuread" {
}

provider "azurecaf" {
}

provider "azurerm" {
  alias           = "mgmt"
  subscription_id = var.management_subscription
  features {
  }
}

provider "azurerm" {
  features {
  }
}

provider "random" {
}

provider "time" {
}
