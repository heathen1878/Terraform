terraform {
    required_version = ">= 1.0.0"
    required_providers {
        source = "hashicorp/azurerm"
        version = ">= 2.0"
    }
    backend "azurerm" {
        resource_group_name = ""
        storage_account_name = ""
        container_name = ""
        key = ""
    }
}