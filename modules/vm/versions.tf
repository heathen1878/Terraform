terraform {
  required_version = "~> 1.1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.89.0"
    }
    random = {
    }
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
  }
}