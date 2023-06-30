output "dns" {
  value = {
    zones = {
      public  = module.dns.public_dns_zones
      private = module.dns.private_dns_zones
    }
  }
}