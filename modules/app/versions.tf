terraform {
  required_version = "~> 1.1.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    random = {
    }
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
  }
}