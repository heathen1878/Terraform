data "azurerm_client_config" "current" {
}

data "terraform_remote_state" "aad" {
    backend = "azurerm"
    
    config = {
        storage_account_name = "sthn37mgfywa7g4"
        container_name       = "learning"
        key                  = "aad.tfstate"
    }
    
}

data "terraform_remote_state" "config" {
    backend = "azurerm"
    
    config = {
        storage_account_name = "sthn37mgfywa7g4"
        container_name       = "learning"
        key                  = "config.tfstate"
    }
    
}