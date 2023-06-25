data "terraform_remote_state" "global_config" {
  backend = "azurerm"

  config = {
    storage_account_name = var.state_storage_account
    container_name       = format("%s-%s", var.tenant_id, var.location)
    key                  = "global_config.tfstate"
  }

}
