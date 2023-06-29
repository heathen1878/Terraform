data "azuread_client_config" "current" {
}

# tflint-ignore: terraform_unused_declarations
data "azurerm_key_vault" "bootstrap_key_vault" {
  provider = azurerm.mgmt

  name                = var.bootstrap.key_vault.name
  resource_group_name = var.bootstrap.key_vault.resource_group
}

data "cloudflare_accounts" "account" {
  name = var.cloudflare_account_name
}

data "cloudflare_ip_ranges" "cloudflare" {}