data "cloudflare_accounts" "account" {
  for_each = var.account_names

  name = each.value.account_name
}