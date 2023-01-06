resource "azurerm_public_ip" "publicIPAddress" {
  name = format("%s-%s", azurecaf_name.publicIPAddress.result, "1")
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location = var.location
  allocation_method = "Dynamic"
  tags = merge(var.tags, {vNetGateway = azurecaf_name.vNetGateway.result})
}

resource "azurerm_virtual_network_gateway" "vNetGateway" {
    name = azurecaf_name.vNetGateway.result
    resource_group_name = azurerm_resource_group.resourceGroup.name
    location = var.location
    type = var.vNetGateway.type
    vpn_type = var.vNetGateway.vpn_type
    sku = var.vNetGateway.sku
    enable_bgp = var.vNetGateway.bgp

    ip_configuration {
        name = "GatewaySubnet"
        public_ip_address_id = azurerm_public_ip.publicIPAddress.id
        private_ip_address_allocation = "Dynamic"
        subnet_id = azurerm_subnet.hubvNet_subnets["GatewaySubnet"].id
    }

    vpn_client_configuration {
        address_space = [ var.vNetGateway.clientAddressSpace ]
        aad_tenant = format("%s%s","https://login.microsoftonline.com/", data.azurerm_client_config.current.tenant_id)
        aad_audience = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"         
        aad_issuer = format("%s%s%s", "https://sts.windows.net/", data.azurerm_client_config.current.tenant_id, "/")      
        vpn_client_protocols = ["OpenVPN"]
    }

    tags = var.tags

    # It can take 60 minutes plus to create a vNet Gateway
    timeouts {
      create = "90m"
    }

}