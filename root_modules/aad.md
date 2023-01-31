[Home](https://github.com/heathen1878/Terraform/blob/main/root_modules/readme.md)

# AAD config

The aad.tf is used to define aad applications, aad users, and aad groups. It also dynamically calculates any group memberships and outputs them.

## Example AAD App

```hcl
key = {
    display_name = "AAD App"
}
```

## Example AAD User

```hcl
key = {
    forename      = "John"
    surname       = "Doe"
    domain_suffix = var.domain_suffix
    enabled       = true
    aad_groups    = [
        # From the groups example below
        "group_key",
        "group2_key"
    ]
    job_title     = "Administrator"
    kv = [
        # a list of key vaults where the password for this user should be stored*
        "key_vault_key"
    ]
    expire_password_after              = 5
    rotate_password_days_before_expiry = 3
    generate_ssh_keys                  = true
} 
```
* [key vaults]()

## Example AAD group

```hcl
group_key = {
    description = "A group"
}
group2_key = {
    description "Another group"
}
```

## Outputs

