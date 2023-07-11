
# Root Modules

[Home](../README.md)

## Examples

The configuration root modules create outputs only, these can be used later by other root modules to create actual resources.

### Global configuration

Using the helper [scripts](../scripts/readme.md)

```shell
tfauth

tfset global global_config

tfinit && tfplan

tfapply
```

### Environment configuration

Using the helper [scripts](../scripts/readme.md)

```shell
tfauth

tfset ne-dev config

tfinit && tfplan

tfapply
```
