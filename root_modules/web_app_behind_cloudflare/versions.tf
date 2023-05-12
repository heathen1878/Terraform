terraform {
  required_version = "~> 1.4.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.45.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.5.0"
    }
    ionosdeveloper = {
      source  = "ionos-developer/ionosdeveloper"
      version = "0.0.1"
    }
  }
}
