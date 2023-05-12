resource "tls_private_key" "origin_certificate" {
    for_each = var.origin_certificate

    algorithm = each.value.algorithm
}

resource "tls_cert_request" "origin_certificate" {
    for_each = var.origin_certificate

    key_algorithm = tls_private_key.origin_certificate.algorithm
    private_key_pem = tls_private_key.origin_certificate.private_key_pem

    subject {
        common_name = each.value.common_name
        country = each.value.country
                    locality = each.value.locality
                    organization = each.value.organization
                    organizational_unit = each.value.organizational_unit
                    postal_code = each.value.postal_code
                    street_address = each.value.street_address
    }

}

resource "cloudflare_origin_ca_certificate" "origin_certificate" {

}


# references
# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/origin_ca_certificate