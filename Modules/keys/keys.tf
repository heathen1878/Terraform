locals {

    aad_users_generate_ssh_keys = flatten([
        for aad_user_key, aad_user_value in data.terraform_remote_state.config.outputs.aad_users : [
            for aad_kv_location_value in aad_user_value.kv : {
                user       = aad_user_value.formatted_user_principal_name
                filename   = aad_user_key
                kv         = aad_kv_location_value
            }
        ]
    ])

    aad_users_generate_ssh_keys_map = {
        for aad_key, aad_value in local.aad_users_generate_ssh_keys : format("%s_ssh_%s", aad_value.filename, aad_value.kv) => aad_value
    }

    virtual_machine_generate_ssh_keys = flatten([
        for virtual_machine_key, virtual_machine_value in data.terraform_remote_state.config.outputs.virtual_machines : [
            for virtual_machine_kv_value in virtual_machine_value.kv : {
                user       = virtual_machine_value.admin_username
                filename   = virtual_machine_value.admin_username
                kv         = virtual_machine_kv_value
            }
            
        ]
        if virtual_machine_value.operating_system == "linux"
    ])

    virtual_machine_generate_ssh_keys_map = {
        for virtual_machine_key, virtual_machine_value in local.virtual_machine_generate_ssh_keys : format("%s_ssh_%s", virtual_machine_value.filename, virtual_machine_value.kv) => virtual_machine_value
    }

    generate_ssh_keys = merge(local.aad_users_generate_ssh_keys_map, local.virtual_machine_generate_ssh_keys_map)

    user_ssh_keys_output = flatten([
        for aad_user_key, aad_user_value in data.terraform_remote_state.config.outputs.aad_users : [
            for aad_kv_location_key, aad_kv_location_value in aad_user_value.kv : {
                user       = aad_user_value.formatted_user_principal_name
                filename   = aad_user_key
                kv         = aad_kv_location_value
                passphrase = random_password.ssh_keys[format("%s_ssh_%s", aad_user_key, aad_kv_location_value)].result
            }
        ]       
    ])
    
    user_ssh_keys_output_map = {
        for aad_key, aad_value in local.user_ssh_keys_output : format("%s_ssh_%s", aad_value.filename, aad_value.kv) => aad_value
    }

    virtual_machine_ssh_keys_output = flatten([
        for virtual_machine_key, virtual_machine_value in data.terraform_remote_state.config.outputs.virtual_machines : [
            for virtual_machine_kv_value in virtual_machine_value.kv : {
                user       = virtual_machine_value.admin_username
                filename   = virtual_machine_value.admin_username
                kv         = virtual_machine_kv_value
                passphrase = random_password.ssh_keys[format("%s_ssh_%s", virtual_machine_value.admin_username, virtual_machine_kv_value)].result
            }
        ]
        if virtual_machine_value.operating_system == "linux"
    ])
    
    virtual_machine_ssh_keys_output_map = {
        for virtual_machine_key, virtual_machine_value in local.virtual_machine_ssh_keys_output : format("%s_ssh_%s", virtual_machine_value.filename, virtual_machine_value.kv) => virtual_machine_value
    }

    ssh_keys_output_map = merge(local.user_ssh_keys_output_map, local.virtual_machine_ssh_keys_output_map)

}

resource "null_resource" "ssh_keys" {
    for_each = local.generate_ssh_keys

    triggers = {
        # if a new SSH key is required then uncomment the line below
        #run = timestamp()
    }

    provisioner "local-exec" {
        #command = format("%s/scripts/generate_ssh_keys.sh", path.root) # Linux
        command = format("%s/scripts/generate_ssh_keys.ps1", path.root) # Windows
        interpreter = ["PowerShell", "-Command"] # comment out for Linux

        environment = {
            passphase = random_password.ssh_keys[each.key].result,
            comment = format("%s SSH Key", each.value.user),
            filename = format(".\\keys\\%s",each.value.filename)
        }
    }

}