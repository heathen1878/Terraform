<#
.SYNOPSIS
    Sets environment variables for Terraform

.NOTES
    Version:        1.0.0.0
    Author:         Dom Clayton
    Creation Date:  24/03/2022
    

.EXAMPLE

    setup.ps1 -environment global -module global

    setup.ps1 -environment [namespace-environment] -module [module]
    setup.ps1 -environment dom-learning -module config

    setup.ps1 -environment [namespace-environment] -module [module] -location [location]
    setup.ps1 -environment dom-learning -module config -location "West Europe"

#>

[CmdletBinding()]
Param
(
    [Parameter(Mandatory=$false)]
    [string]
    $environment_directory=(-Join($env:USERPROFILE, "\configurations\environments")),
    [Parameter(Mandatory)]
    [string]
    $environment,
    [Parameter(Mandatory=$false)]
    [string]
    $key_vault="kv-hmflu45flwcmm",
    [Parameter(Mandatory=$false)]
    [string]
    $location="North Europe",
    [Parameter(Mandatory)]
    [string]
    $module,
    [Parameter(Mandatory=$false)]
    [string]
    $root_modules_directory=(Get-Location).Path,
    [Parameter(Mandatory=$false)]
    [string]
    $storage_account="sthmflu45flwcmm"
)

# Set environment and namespace from provided environment
$namespace=$environment.Split('-')[0]
$env = $environment.Split('-')[1]
$location_no_spaces = $location.Replace(" ", "-").ToLower()
$tenant_id = (Get-AzTenant).Id

# Global backend.tfvars content
$global_backend = @"
storage_account_name = "$($storage_account)"
container_name       = "$($tenant_id)"
key                  = "$($module).tfstate"
"@

$global_variables = @"
management_groups = {
    devtest = {
        display_name = "Development and Test subscriptions"
        subscriptions = []
    }
    production = {
        display_name = "Production subscriptions"
        subscriptions = []
    }
}
"@

# Environment specific backend.tfvars content
$environment_backend = @"
storage_account_name = "$($storage_account)"
container_name       = "$($environment)-$($location_no_spaces)"
key                  = "$($module).tfstate"
"@

$environment_variables = @"
location    = "$($location)"
environment = "$($env)"
namespace   = "$($namespace)"
"@

# Check whether the terraform executable exists
Try {

    (Get-Command terraform.exe -ErrorAction Stop).Path | Out-Null

}
Catch {

    Write-Warning ('Terraform executable not found. Ensure it exists in one of the locations below')
    $env:Path.Split(';') | ForEach-Object {
    
        Write-Warning $_

    }

}

# Check whether the root module directory exists
If (Test-Path (-Join($root_modules_directory, '\root_modules\', $module))){

    # Set environment variable
    $env:TF_MODULE_CODE=(-Join($root_modules_directory, '\root_modules\', $module))

} Else {

    Write-Warning ('Cannot find the root module: {0} in {1}' -f $module, $root_modules_directory)
    break

}

# global configuration or environment configuration
switch ($environment){

    'global' {

        # Check whether the environment configuration directory exists
        If (Test-Path $environment_directory){

            If (-not (Test-Path (-Join($environment_directory, '\', $tenant_id)))){

                New-Item -Path $environment_directory -Name $tenant_id -ItemType Directory | Out-Null   
    
            }

            $env:TF_ENVIRONMENT_VARS=(-Join($environment_directory, '\', $tenant_id))

            # Check for backend.tfvars and variables.tfvars, create if necessary with backend variables.
            if (-not (Test-Path (-Join($env:TF_ENVIRONMENT_VARS, '\backend.tfvars')))){
    
                # Create backend.tfvars for remote state
                New-Item -Path $env:TF_ENVIRONMENT_VARS -Name 'backend.tfvars' -ItemType File | Out-Null
    
                $global_backend | Set-Content (-Join($env:TF_ENVIRONMENT_VARS, '\backend.tfvars'))
    
            }                
    
            if (-not (Test-Path (-Join($env:TF_ENVIRONMENT_VARS, '\', $environment,'.tfvars')))){
    
                # Create environment.tfvars
                New-Item -Path $env:TF_ENVIRONMENT_VARS -Name (-Join($environment, '.tfvars')) -ItemType File | Out-Null
    
                $global_variables | Set-Content (-Join($env:TF_ENVIRONMENT_VARS, '\', $environment,'.tfvars'))

            }
    
        } Else {

            Write-Warning ('Cannot find the environment configuration directory: {0} in {1}' -f $tenant_id, $environment_directory)
            break

        }
            
    }
    
    Default {

        # Setup the environment directory 
        If (-not (Test-Path (-Join($environment_directory, '\', $environment, '\', $location)))){

            New-Item -Path (-Join($environment_directory, '\', $environment)) -Name "$location" -ItemType Directory | Out-Null

        }

        # Setup a module directory for the environment.
        If (-not (Test-Path (-Join($environment_directory, '\', $environment, '\', $location, '\', $module)))){

            New-Item -Path (-Join($environment_directory, '\', $environment, '\', $location)) -Name $module -ItemType Directory | Out-Null

        }

        $env:TF_ENVIRONMENT_VARS=(-Join($environment_directory, '\', $environment, '\', $location, '\', $module))

        # Check for backend.tfvars and variables.tfvars, create if necessary with backend variables.
        if (-not (Test-Path (-Join($env:TF_ENVIRONMENT_VARS, '\backend.tfvars')))){
    
            # Create backend.tfvars for remote state
            New-Item -Path $env:TF_ENVIRONMENT_VARS -Name 'backend.tfvars' -ItemType File | Out-Null

            $environment_backend | Set-Content (-Join($env:TF_ENVIRONMENT_VARS, '\backend.tfvars'))

        }                

        if (-not (Test-Path (-Join($env:TF_ENVIRONMENT_VARS, '\', $environment,'.tfvars')))){

            # Create environment.tfvars
            New-Item -Path $env:TF_ENVIRONMENT_VARS -Name (-Join($environment, '.tfvars')) -ItemType File | Out-Null

            $environment_variables | Set-Content (-Join($env:TF_ENVIRONMENT_VARS, '\', $environment,'.tfvars'))

        }

    }

}

$subscription_id = Get-AzKeyVaultSecret -VaultName $key_vault -Name "mgmt" -AsPlainText
$env:TF_VAR_management_subscription = $subscription_id
Set-AzContext -Subscription $subscription_id | Out-Null
$subscription_name = (Get-AzContext).Subscription.Name

# Get access key from storage account
$ACCESS_KEY = Get-AzStorageAccountKey -ResourceGroupName (Get-AzResource -Name $storage_account).ResourceGroupName -Name $storage_account | Where-Object {$_.KeyName -eq "key1"}

# Get subscription id for the environment.
switch ($environment){
    'global' {
        $subscription_id = Get-AzKeyVaultSecret -VaultName $key_vault -Name "mgmt" -AsPlainText
    }
    'prod' {
        $subscription_id = Get-AzKeyVaultSecret -VaultName $key_vault -Name "prod" -AsPlainText
    }
    'non-prod' {
        $subscription_id = Get-AzKeyVaultSecret -VaultName $key_vault -Name "non-prod" -AsPlainText
    }
    Default {
        $subscription_id = Get-AzKeyVaultSecret -VaultName $key_vault -Name "non-prod" -AsPlainText
    }
}

Set-AzContext -Subscription $subscription_id | Out-Null
$subscription_name = (Get-AzContext).Subscription.Name

# Get the Microsoft Azure published address ranges json link
If ($module -eq "global_config"){
    $azure_ip_ranges=((Invoke-WebRequest -Uri "https://www.microsoft.com/en-us/download/confirmation.aspx?id=56519" -UseBasicParsing).Links | Where-Object href -like "*json" | Select-Object href -First 1).href
    $env:TF_VAR_azure_ip_ranges_json_url=$azure_ip_ranges
}

# Get Azure DevOps service url
if ($module -eq "azdo"){
    $AZDO_ORG_SERVICE_URL = Get-AzKeyVaultSecret -VaultName $key_vault -Name "azdo-service-url" -AsPlainText
}

# Get Azure DevOps Access Token
if ($module -eq "azdo"){
    # Set the AzDo environment variable AZDO_PERSONAL_ACCESS_TOKEN
    $AZDO_PERSONAL_ACCESS_TOKEN = Get-AzKeyVaultSecret -VaultName $key_vault -Name "azdo-pat-token-tf" -AsPlainText
}

# Set environment variables for Terraform
$env:TF_ENVIRONMENT=$env
$env:TF_NAMESPACE=$namespace
$env:TF_MODULE=$module
$env:TF_DATA_DIR=(-Join($env:TF_ENVIRONMENT_VARS, '\.terraform'))
$env:ARM_SUBSCRIPTION_ID=$subscription_id
$env:ARM_ACCESS_KEY=($ACCESS_KEY).Value
$env:ARM_TENANT_ID=$tenant_id

if ($module -eq "azdo"){
    $env:AZDO_ORG_SERVICE_URL=$AZDO_ORG_SERVICE_URL
    $env:AZDO_PERSONAL_ACCESS_TOKEN=$AZDO_PERSONAL_ACCESS_TOKEN
}

Write-host ('')
Write-Host ('Terraform Environment configuration:') -ForegroundColor Yellow
Write-Host ('--------------------------------------------------------------') -ForegroundColor White
Write-Host ('Environment configuration path: {0}' -f $env:TF_ENVIRONMENT_VARS) -ForegroundColor Magenta
Write-Host ('Terraform deployment path: {0}' -f $env:TF_MODULE_CODE) -ForegroundColor Magenta
Write-Host ('Terraform data path: {0}' -f $env:TF_DATA_DIR) -ForegroundColor Magenta
if ($environment -eq "global") {
    Write-Host ('Azure Tenant Name: {0}' -f (Get-AzTenant).Name) -ForegroundColor Magenta
}
Write-Host ('Azure Subscription Name: {0}' -f $subscription_name) -ForegroundColor Magenta
if ($module -eq "azdo"){
    Write-Host ('Azure DevOps Service Url: {0}' -f $env:AZDO_ORG_SERVICE_URL) -ForegroundColor Magenta
}
