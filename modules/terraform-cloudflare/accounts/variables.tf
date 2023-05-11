variable "account_names" {
  description = "A string representation of the account name"
  type        = map(object(
    {
      account_name = string
    }
  ))
}