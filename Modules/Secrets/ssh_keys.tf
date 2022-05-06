resource "local_file" "ssh_keys" {
    for_each = local.aad_users_generate_ssh_keys_map

    # Linux
    #content = templatefile("./templates/generate_ssh_keys.sh.tftpl", {
    #    passphase = random_password.ssh_keys[each.key].result,
    #    comment = format("%s SSH Key", each.value.user),
    #    filename = each.value.filename
    #    }
    #)

    # Windows
    content = templatefile("./templates/generate_ssh_keys.ps1.tftpl", {
        passphase = random_password.ssh_keys[each.key].result,
        comment = format("%s SSH Key", each.value.user),
        filename = format(".\\keys\\%s",each.value.filename)
        }
    )   

    # Linux
    #filename = format("./keys/%s.sh",each.value.filename)

    # Windows
    filename = format(".\\keys\\%s.ps1",each.value.filename)

}

resource "null_resource" "ssh_keys" {
    for_each = local.aad_users_generate_ssh_keys_map

    triggers = {
        # if a new SSH key is required then uncomment the line below
        #run = timestamp()
    }

    provisioner "local-exec" {
        command = local_file.ssh_keys[each.key].filename
        interpreter = ["PowerShell", "-Command"]
    }

    depends_on = [
        local_file.ssh_keys
    ]

}