resource "azurerm_key_vault_secret" "secret" {
  # Because the value of the secret is sensitive, Terraform complains about the for_each exposing the secret
  # but the value of the certificate is defined as sensitive anyway thus not visible
  for_each = nonsensitive(var.secrets)

  name            = each.value.name
  value           = each.value.value
  key_vault_id    = each.value.key_vault_id
  content_type    = each.value.content_type
  expiration_date = each.value.expiration_date
}
