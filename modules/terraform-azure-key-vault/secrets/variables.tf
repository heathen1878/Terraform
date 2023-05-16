variable "secrets" {
  description = "A map of secrets to add to Key Vault"
  type = map(object(
    {
      name            = string
      value           = string
      key_vault_id    = string
      content_type    = string
      expiration_date = string
    }
  ))
  sensitive = true
}

