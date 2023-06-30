data "terraform_remote_state" "config" {
  backend = "azurerm"

  config = {
    storage_account_name = var.state_storage_account
    container_name       = format("%s-%s-%s", var.namespace, var.environment, var.location)
    key                  = "config.tfstate"
  }

}