terraform {
    required_version = "~> 0.14.0"
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "2.89.0"
        }
        random = {

        }
        azurecaf = {
            source = "aztfmod/azurecaf"
            version = "1.2.10"
        }
    }
}

provider "azurerm" {
    features {
    }
}

provider "azurerm" {
    features {
        resource_group {
            prevent_deletion_if_contains_resources = true
        }
    }
    alias = "prevent-rg-deletion-if-not-empty"
}

provider "random" {
}

provider "azurecaf" {     
}

