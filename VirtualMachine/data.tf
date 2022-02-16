data "azurerm_client_config" "current" {
}
/*
data "terraform_remote_state" "virtualNetwork" {
    backend = "azurerm"
    config = {
        storage_account_name = ""
    }    
}
*/