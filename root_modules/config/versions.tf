terraform {
  required_version = "~> 1.4.0"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.38"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.25"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.45.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.5.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}