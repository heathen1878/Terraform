output "public_ssh_keys" {
    value     = azurerm_key_vault_secret.public_ssh_key
    sensitive = true
}