resource "azurerm_key_vault" "keyVault" {
    name = azurecaf_name.keyVault.result
    resource_group_name = azurerm_resource_group.resourceGroup.name
    location = var.location
    tenant_id = data.azurerm_client_config.current.tenant_id
    enable_rbac_authorization = true
    sku_name = var.keyVaultSku
}

resource "azurerm_key_vault_secret" "sshKeys" {
    for_each = var.virtualMachines
    name = each.value.computerName
    key_vault_id = azurerm_key_vault.keyVault.id
    value = base64encode(file(format("%s/Artifacts/%s.pem", path.root, each.value.computerName)))
    content_type = "SSH Key"
}