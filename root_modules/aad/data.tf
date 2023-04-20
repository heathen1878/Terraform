data "terraform_remote_state" "global" {
  backend = "azurerm"

  config = {
    storage_account_name = "sthn37mgfywa7g4"
    container_name       = var.tenant_id
    key                  = "global.tfstate"
  }
}