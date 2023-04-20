variable "users" {
  description = "A map of users to create"
  type = map(object(
    {
        user_principal_name = string
        given_name = string
        surname = string
        display_name = string
        mail_nickname = string
        job_title = string
        password = string
        account_enabled = bool
    }
  ))
}