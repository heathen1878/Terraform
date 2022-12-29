output "ssh_keys" {
  value     = local.ssh_keys_output_map
  sensitive = true
}