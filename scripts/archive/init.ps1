<#
.SYNOPSIS
    Initialises Terraform for the root module defined by $env:TF_MODULE_CODE

.NOTES
    Version:        1.0.0.0
    Author:         Dom Clayton
    Creation Date:  06/04/2022
    

.EXAMPLE
    
#>

# Check whether .terraform_cache exists in the users home directory
If (-not (Test-Path (-Join($HOME,'\.terraform_cache')))){

    Write-Output ('.terraform_cache doesn''t exist, creating directory')
    New-Item -Path $HOME -ItemType Directory -Name '.terraform_cache' | Out-Null

}

# Set the $env:TF_PLUGIN_CACHE_DIR
$env:TF_PLUGIN_CACHE_DIR=(-Join($HOME,'\.terraform_cache'))
Write-Host ('Terraform plugin cache set to {0}' -f $env:TF_PLUGIN_CACHE_DIR) -ForegroundColor Green

If ((Test-Path env:TF_ENVIRONMENT_VARS) -and (Test-Path env:TF_MODULE_CODE)){

    terraform fmt -recursive $env:TF_MODULE_CODE
    terraform fmt -recursive $env:TF_ENVIRONMENT_VARS

    # Check whether the container exists in the storage account
    # read in the backend.tfvars
    [pscustomobject]$backend = Get-Content (-Join($env:TF_ENVIRONMENT_VARS, '\backend.tfvars'))
    $storage_account_name = $backend.Item(0).Substring(24, $backend.Item(0).Length -25)
    $container_name = $backend.Item(1).Substring(24, $backend.Item(1).Length -25)

    Write-Host ('Checking for {0} in {1}' -f $container_name, $storage_account_name) -ForegroundColor Cyan
    if ((az storage container exists --auth-mode login --account-name $storage_account_name --name $container_name --output Json | ConvertFrom-Json).exists.ToString() -eq "False"){

        # container doesn't exists, create it.
        Write-Host ('Creating {0} in {1}' -f $container_name, $storage_account_name) -ForegroundColor Green
        az storage container create --auth-mode login --account-name $storage_account_name --name $container_name | Out-Null

    }


    Write-Host ('Initialising Terraform module {0}' -f $env:TF_MODULE) -ForegroundColor Green
    terraform -chdir="$env:TF_MODULE_CODE" init -backend-config="$env:TF_ENVIRONMENT_VARS\backend.tfvars" -reconfigure -upgrade
    Write-Host ('')
    Write-Host ('')
    
} Else {

    Write-Warning ('$env:TF_ENVIRONMENT_VARS and or $env:TF_MODULE_CODE have not been set. Please run tfset')

}
