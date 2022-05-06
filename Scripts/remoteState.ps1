<#
.SYNOPSIS
    Creates a storage account for Terraform remote state

.NOTES
    Version:        1.0.0.0
    Author:         Dom Clayton
    Creation Date:  28/03/2022
    
.ENVIRONMENT
    The environment...

.EXAMPLE
    remoteState.ps1
#>

. .\Scripts\Connect-Az.ps1
. .\Scripts\Set-Prompt.ps1
. .\Scripts\Set-Subscription.ps1

# Connect to Azure
Connect-Az

# Set the subscription
Set-Subscription

$deployment = New-AzSubscriptionDeployment `
-Name 'tfremotestate' `
-Location 'North Europe' `
-TemplateFile .\Remote_State\azuredeploy.json `
-TemplateParameterFile .\Remote_State\azuredeploy.parameters.json

Write-Host ('The storage account {0} has been deployed to the following resource group {1} in subscription {2}' `
-f $deployment.Outputs.storageAccount_Id.Value.split('/')[8], `
$deployment.Outputs.storageAccount_Id.Value.split('/')[4], `
$deployment.Outputs.storageAccount_Id.Value.split('/')[2]) -ForegroundColor Green

Disconnect-AzAccount | Out-Null