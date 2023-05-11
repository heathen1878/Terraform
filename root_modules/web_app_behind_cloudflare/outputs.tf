output "cloudflare_account" {
  value = module.cloudflare_account.account
}

output "cloudflare_zone" {
  value = module.cloudflare_zone.zone
}

output "web_app_ip_restrictions" {
  value = module.cloudflare_ip_addresses.ip_addresses
}