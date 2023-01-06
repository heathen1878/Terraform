terraform {
    required_version = "~> 0.15.0"
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~> 2.89.0"
        }
        azuread = {
            source = "hashicorp/azuread"
            version = "~> 2.18.0"
        }
        random = {

        }
        azurecaf = {
            source = "aztfmod/azurecaf"
            version = "~> 1.2.10"
        }
    }
}