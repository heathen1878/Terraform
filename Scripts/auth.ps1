<#
.SYNOPSIS
    Authenticates az cli and Powershell with Azure.

.NOTES
    Version:        1.0.0.0
    Author:         Dom Clayton
    Creation Date:  24/03/2022
    

.EXAMPLE

    auth.ps1

#>

# Hide warnings
$WarningPreference = "SilentlyContinue"

Write-host ('Authenticating Az Cli') -ForegroundColor Green
az login --query "sort_by([].{name:name, state:state, isDefault:isDefault, subscriptionId:id, tenantId:tenantId},&name)" --output table --only-show-errors

Write-Host ('Authenticating Azure PowerShell') -ForegroundColor Green
Connect-AzAccount | Out-Null
Write-Host ("PowerShell connected to Azure AD tenant: {0}" -f (Get-AzTenant -TenantId (Get-AzContext).Tenant.Id).Name) -ForegroundColor Cyan
Write-Host ("PowerShell using subscription: {0}" -f (Get-AzContext).Subscription.Name) -ForegroundColor Cyan

Write-Host ('Getting an access token') -ForegroundColor Green
$access_token = (Get-AzAccessToken -TenantId (Get-AzContext).Tenant.Id).Token
$env:TF_VAR_access_token=$access_token