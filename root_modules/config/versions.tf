terraform {
  required_version = "~> 1.1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.37.0"
    }
    random = {
      source = "hashicorp/random"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.10"
    }
    time = {
      source = "hashicorp/time"
    }
  }
}