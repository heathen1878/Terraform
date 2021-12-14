terraform {
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

provider "random" {
}

provider "azurecaf" {
      
}


resource "random_id" "resourceGroup" {
    keepers = {
        location = trimspace("${ var.location }")
        subscription = "${ var.subscriptionId }"
    }
    byte_length = 16
}

resource "azurecaf_name" "resourceGroup" {
    name = lower(random_id.resourceGroup.id)
    resource_type = "azurerm_resource_group"
    suffixes = ["appname"]
    random_length = 5
    clean_input = true
}

resource "azurerm_resource_group" "resourceGroup" {
    name = azurecaf_name.resourceGroup.result
    location = var.location
}

