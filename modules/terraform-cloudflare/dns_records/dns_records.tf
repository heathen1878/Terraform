resource "cloudflare_record" "dns_record" {
  for_each = var.dns_record

  zone_id = each.value.zone_id
  name    = each.value.name
  proxied = each.value.proxied
  value   = each.value.value
  type    = each.value.type
  ttl     = each.value.ttl
}

locals {

  dns_record_output = {
    for key, value in cloudflare_record.dns_record : key => {
      id = value.id
    }
  }

}