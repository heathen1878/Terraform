data "azuread_client_config" "current" {
}

data "terraform_remote_state" "config" {
  backend = "azurerm"

  config = {
    storage_account_name = "sthn37mgfywa7g4"
    container_name       = format("%s-%s-%s", var.namespace, var.environment, replace(lower(var.location), " ", "-"))
    key                  = "config.tfstate"
  }

}