variable "origin_certificate" {
  description = "A map object used to create a Cloudflare origin certificate"
  type = map(object(
    {
      algorithm = string
      dns_names = list(string)
      subject = object(
        {
          common_name         = string
          country             = string
          locality            = string
          organization        = optional(string)
          organizational_unit = string
          postal_code         = optional(string)
          street_address      = optional(list(string), [])
        }
      )
      min_days_for_renewal = optional(number, 14)
      requested_validity   = optional(number, 90)
    }
  ))
}