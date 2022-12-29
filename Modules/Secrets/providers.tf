provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "azurecaf" {
}

provider "random" {
}

provider "template" {
  features {}
}

provider "null" {
}

provider "local" {
}