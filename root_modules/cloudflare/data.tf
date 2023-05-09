data "terraform_remote_state" "config" {
    backend = "azurerm"

    config = {
      storage_account_name = "sthn37mgfywa7g4"
        container_name       = format()
        key                  = "config.tfstate"
    }
}