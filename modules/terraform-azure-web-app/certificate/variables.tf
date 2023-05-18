variable "certificates" {
  description = "A map of certificates to add to app services"
  type = map(object(
    {
      name                = string
      resource_group_name = string
      location            = string
      app_service_plan_id = string
      key_vault_secret_id = string
    }
  ))
}