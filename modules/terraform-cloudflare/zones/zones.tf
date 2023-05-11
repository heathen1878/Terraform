resource "cloudflare_zone" "zone" {
  for_each = var.zones

  account_id = each.value.account_id
  zone       = each.value.zone
}