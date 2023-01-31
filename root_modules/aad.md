[Home](https://github.com/heathen1878/Terraform/blob/main/root_modules/readme.md)

The configuration root modules take input from variables, predefined locals and data resources to provide outputs which can be used by Terraform modules, for example...

...the aad module 

    #key = {
    #  forename      = "Platform"
    #  surname       = "Automation"
    #  domain_suffix = var.domain_suffix
    #  enabled       = true
    #  aad_groups    = [
    #    "group_key"
    #  ]
    #  job_title     = "Automation Account"
    #  kv = [
    #    # a list of key vaults where the secrets should be stored - matched up with local.key_vaults
    #    "key_vault_key"
    #  ]
    #  expire_password_after              = 5
    #  rotate_password_days_before_expiry = 3
    #  generate_ssh_keys                  = true
    #} 