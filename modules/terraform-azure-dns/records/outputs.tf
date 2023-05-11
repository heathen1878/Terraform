output "records" {
    value = {
        nameservers = azurerm_dns_ns_record.name_servers
    }
}