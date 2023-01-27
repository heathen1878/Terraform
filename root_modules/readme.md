
[Home](https://github.com/heathen1878/Terraform/blob/main/README.md)
# Root Modules

## Examples

The configuration root modules create outputs only, these can be used later by other root modules to create actual resources.

### Global configuration

Using the helper [scripts](https://github.com/heathen1878/Terraform/blob/main/Scripts/readme.md)
```PowerShell
tfset -environment global -module global_config
tfinit && tfplan
```

### Environment configuration

Using the helper [scripts](https://github.com/heathen1878/Terraform/blob/main/Scripts/readme.md)
```PowerShell
tfset -environment dom-learning -module config
tfinit && tfplan
```

#TODO Create a helper script for tfapply.
