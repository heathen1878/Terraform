[Home](https://github.com/heathen1878/Terraform/blob/main/README.md)

# Bootstrap configuration

## Validation

[![Validate Terraform Bootstrapping](https://github.com/heathen1878/Terraform/actions/workflows/validate_tf_bootstrapping.yaml/badge.svg)](https://github.com/heathen1878/Terraform/actions/workflows/validate_tf_bootstrapping.yaml)

## Build

[![Deploy Terraform Bootstrapping](https://github.com/heathen1878/Terraform/actions/workflows/deploy_tf_bootstrapping.yaml/badge.svg)](https://github.com/heathen1878/Terraform/actions/workflows/deploy_tf_bootstrapping.yaml)

## Key Vault

A key vault to store secrets such as PAT tokens, DevOps urls, subscriptions for environments or specific projects. These are used by [setup.ps1](https://github.com/heathen1878/Terraform/blob/main/Scripts/setup.ps1) to set environment variables for Terraform.

## Storage Account

A storage account to hold Terraform state.

## azuredeploy.parameters.json

Your ARM parameter file should be similar to this:

```json
...
    "parameters": {
        "cert_officers_group": {
            "value": "group object id from AAD"
        },
        "dedicated_subscription": {
            "value": "Yes or No"
        },
        "environment": {
            "value": "Production"
        },
        "key_vault_ip_rules": {
            "value": [
                "One or more IP address ranges...",
                "...to restrict access to storage and key vault"
            ]
        },
        "kv_admin_group": {
            "value": "group object id from AAD"
        },
        "location": {
            "value": "Some location"
        },
        "resource_tags": {
            "value": {
                "application": "Terraform Configuration",
                "businessContact": "",
                "department": "",
                "description": "Contains storage account for Terraform Remote State, and Key Vault for bootstrapping secrets",
                "technicalContact": "",
                "IaC": "ARM"
            }
        },
        "rbac": {
            "value": [
                {
                    "roleId": "acdd72a7-3385-48ef-bd42-f606fba81ae7",
                    "principalId": "group object id from AAD"
                }
            ]
        },
        "secret_officers_group": {
            "value": "group object id from AAD"
        },
        "storage_account_ip_rules": {
            "value": [
                "One or more IP address ranges...",
                "...to restrict access to storage and key vault"
            ]
        },
        "usage": {
            "value": "tfconfiguration"
        }
    }
...
```

## Using PowerShell

```PowerShell
Connect-AzAccount

New-AzDeployment -Name "Terraform-Bootstrap" `
-Location "North Europe" `
-TemplateFile .\bootstrap_configuration\azuredeploy.json `
-TemplateParameterFile .\bootstrap_configuration\azuredeploy.parameters.json
```

## Using Azure DevOps

To use DevOps you need at least a project and service connection setup - see this [readme](https://github.com/heathen1878/ARM-QuickStarts/blob/master/AzureDevOps/readMe.md).

```yaml
```

## Using GitHub Actions

Using the validation [workflow](https://github.com/heathen1878/Terraform/blob/main/.github/workflows/validate_tf_bootstrapping.yaml) and deployment [workflow](https://github.com/heathen1878/Terraform/blob/main/.github/workflows/deploy_tf_bootstrapping.yaml). Create a Branch and Pull Request.