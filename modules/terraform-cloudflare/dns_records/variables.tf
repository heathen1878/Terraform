variable "dns_record" {
  description = "A map of dns records"
  type = map(object(
    {
      name    = string
      proxied = bool
      ttl     = number
      type    = string
      value   = string
      zone_id = string
    }
  ))
}