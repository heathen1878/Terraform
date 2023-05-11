output "ip_addresses" {
    value = {
        ipv4 = data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks
    }
}