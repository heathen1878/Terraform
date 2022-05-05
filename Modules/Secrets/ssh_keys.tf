resource "local_file" "ssh_keys" {
    for_each = local.aad_users_generate_ssh_keys_map

    content = templatefile("./templates/generate_ssh_keys.sh.tftpl", {
        passphase = random_password.ssh_keys[each.key].result,
        comment = format("%s SSH Key", each.value.user),
        filename = each.value.filename
        }
    )

    filename = format("./keys/%s.sh",each.value.filename)

}

resource "null_resource" "ssh_keys" {
    for_each = local.aad_users_generate_ssh_keys_map

    triggers = {
        # if a new SSH key is required then uncomment the line below
        #run = timestamp()
    }

    provisioner "local-exec" {
        command = local_file.ssh_keys[each.key].filename
    }

    depends_on = [
        local_file.ssh_keys
    ]

}