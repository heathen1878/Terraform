terraform {
    required_version = "~> 0.15.0"
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~> 2.89.0"
        }
        random = {
            source = "hashicorp/random"
        }
        azurecaf = {
            source = "aztfmod/azurecaf"
            version = "1.2.10"
        }
        time = {
            source = "hashicorp/time"
        }
    }
}