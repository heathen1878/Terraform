terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.45.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.9.0"
    }
  }
}