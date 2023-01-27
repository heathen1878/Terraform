[Home](https://github.com/heathen1878/Terraform/blob/main/README.md)

# Bootstrap configuration

The Terraform bootstrapping is deployed using ARM templates, e.g. 

Your ARM parameter file should be similar to this:
```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
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
        "locations": {
            "value": [
                "One or more locations...",
                "...to restrict deployments to"
            ]
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
}
```

Using PowerShell:
```PowerShell
Connect-AzAccount

New-AzDeployment -Name "Terraform-Bootstrap" `
-Location "North Europe" `
-TemplateFile .\bootstrap_configuration\azuredeploy.json `
-TemplateParameterFile .\bootstrap_configuration\azuredeploy.parameters.json
```

Using Azure DevOps:
```yaml

```