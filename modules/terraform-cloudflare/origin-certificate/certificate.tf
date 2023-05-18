resource "tls_private_key" "origin_certificate" {
  for_each = var.origin_certificate

  algorithm = each.value.algorithm
}

resource "tls_cert_request" "origin_certificate" {
  for_each = var.origin_certificate

  private_key_pem = tls_private_key.origin_certificate[each.key].private_key_pem

  subject {
    common_name         = each.value.subject.common_name
    country             = each.value.subject.country
    locality            = each.value.subject.locality
    organization        = each.value.subject.organization
    organizational_unit = each.value.subject.organizational_unit
    postal_code         = each.value.subject.postal_code
    street_address      = each.value.subject.street_address
  }

}

resource "cloudflare_origin_ca_certificate" "origin_certificate" {
  for_each = var.origin_certificate

  csr                  = tls_cert_request.origin_certificate[each.key].cert_request_pem
  hostnames            = each.value.dns_names
  min_days_for_renewal = each.value.min_days_for_renewal
  request_type         = "origin-rsa"
  requested_validity   = each.value.requested_validity
}

locals {

  origin_certificate_output = {
    for key, value in cloudflare_origin_ca_certificate.origin_certificate : key => {

    }
  }

}