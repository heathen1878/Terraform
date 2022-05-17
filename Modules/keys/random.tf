resource "random_password" "ssh_keys" {
    for_each = local.generate_ssh_keys

    length  = 24
    special = true

}