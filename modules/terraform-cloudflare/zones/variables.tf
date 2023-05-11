variable "zones" {
  description = "A map of zones and associated accounts."
  type = map(object(
    {
      account_id = string
      zone       = string
    }
  ))
}