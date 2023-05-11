variable "zones" {
  description = "A map of zones and associated accounts."
  type = map(object(
    {
      account_id = string
      zone       = string
      jump_start = bool
      paused     = bool
      plan       = string
      type       = string
    }
  ))
}