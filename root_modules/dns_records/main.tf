module "cloudflare_domain_verification_record" {
  source = "../../modules/terraform-cloudflare/dns_records"

  dns_record = local.web_app_verification_dns_record_cloudflare
}

module "pre_verify_cloudflare_cname_record" {
  source = "../../modules/terraform-cloudflare/dns_records"

  dns_record = local.pre_verify_web_app_cname_dns_record_cloudflare
}

module "azure_domain_verification_record" {
  source = "../../modules/terraform-azure-dns/records"

  record = local.web_app_verification_dns_record_azure
}

module "secure_custom_domain" {
  source = "../../../terraform-azurerm-secure-custom-domain"

  custom_domain = local.web_app_custom_domain
}

module "post_verify_cloudflare_cname_record" {
  source = "../../modules/terraform-cloudflare/dns_records"

  dns_record = local.post_verify_web_app_cname_dns_record_cloudflare
}