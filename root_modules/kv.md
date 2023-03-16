[Home](https://github.com/heathen1878/Terraform/blob/main/root_modules/readme.md)

# KV config

## Key vault example

```hcl
key_vaults = {
    management = {
      resource_group = "management"
    }
    secrets = {

    }
    certificates = {

    }
  }
```

The minimum required for a key vault us a key name.
