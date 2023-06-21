# Modules

[Terraform Registry](https://registry.terraform.io/namespaces/heathen1878)

## Cloudflare

### Accounts

This module will create or get accounts within Cloudflare.

#### resources

cloudflare_account
data.cloudflare_account

#### Dependencies

CLOUDFLARE_API_TOKEN

### Zones

This module will create zones within accounts. The module will also support zone setting overrides, creation of DNS records and zone lockdown configuration.

#### resources

cloudflare_zone
cloudflare_zone_lockdown
cloudflare_zone_settings_override
cloudflare_record

#### Depedendencies

CLOUDFLARE_API_TOKEN
Cloudflare Accounts module

### IP Addresses

This module will get the ipv4 and ipv6 cidr blocks used by Cloudflare.

#### resources

data.cloudflare_ip_ranges

#### Dependencies

CLOUDFLARE_API_TOKEN


