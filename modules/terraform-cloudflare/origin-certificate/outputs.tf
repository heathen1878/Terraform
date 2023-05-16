output "origin_certificate" {
  value     = cloudflare_origin_ca_certificate.origin_certificate
  sensitive = true
}