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

## Azure DevOps

### Projects

This module will create projects and manage their features.

#### Resources

azuredevops_project

#### Dependencies

AZDO_ORG_SERVICE_URL
AZDO_PERSONAL_ACCESS_TOKEN

### Variable Groups

This module will create and manage variable groups

#### Resources

azuredevops_variable_group

#### Dependencies

Azure DevOps project module
AZDO_ORG_SERVICE_URL
AZDO_PERSONAL_ACCESS_TOKEN

### Service Endpoints

This module will create and manage Azure DevOps service endpoints.

#### AzureRM

##### Resources

azuredevops_serviceendpoint_azurerm

##### Dependencies

Azure DevOps project module
AZDO_ORG_SERVICE_URL
AZDO_PERSONAL_ACCESS_TOKEN

## Azure

### Networking Module

This module creates and manages the following networking components:

- Network Watcher
- Virtual Networks
- Subnets
- Route table
- Private DNS
- Private DNS link

#### Resources

azurerm_network_watcher
data.azurerm_network_watcher
azurerm_virtual_network
data.azurerm_virtual_network
azurerm_subnet
data.azurerm_subnet
azurerm_route_table
data.azurerm_route_table
azurerm_private_dns_zone
azurerm_private_dns_zone_virtual_network_link

#### Dependencies

Resource Group module

