terraform {
    required_version = ">= 1.0.0"
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
        environment = "${ var.environment }"
        location = trimspace("${ var.location }")
        subscription = "${ var.subscriptionId }"
    }
    byte_length = 16
}

resource "azurecaf_name" "resourceGroup" {
    name = lower(random_id.resourceGroup.id)
    resource_type = "azurerm_resource_group"
    suffixes = ["${ var.usage }"]
    random_length = 0
    clean_input = true
}

resource "azurerm_resource_group" "resourceGroup" {
    name = azurecaf_name.resourceGroup.result
    location = var.location
    tags = "${var.tags}"
}