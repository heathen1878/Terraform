data "terraform_remote_state" "global_config" {
  backend = "azurerm"

  config = {
    storage_account_name = var.state_storage_account
    container_name       = format("%s-%s", var.namespace, var.location)
    key                  = "global_config.tfstate"
  }

}
