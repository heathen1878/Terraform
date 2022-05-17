<#
.SYNOPSIS
    Sets environment variables for Terraform

.NOTES
    Version:        1.0.0.0
    Author:         Dom Clayton
    Creation Date:  24/03/2022
    

.EXAMPLE

    setup.ps1 -environment [namespace-environment] -module [module] -subscriptionId [subscription guid]
    setup.ps1 -environment dom-learning -module Config -subscription 0000000-0000-0000-0000-00000000

    setup.ps1 -environment [namespace-environment] -module [module] -location [location] -subscriptionId [subscription guid]
    setup.ps1 -environment dom-learning -module Config -location "West Europe"  -subscription 0000000-0000-0000-0000-00000000

#>

[CmdletBinding()]
Param
(
    [Parameter(Mandatory=$false)]
    [string]
    $root_modules_directory=(-join($env:USERPROFILE, '\Source\Terraform')),
    [Parameter(Mandatory=$false)]
    [string]
    $environment_directory=(-Join($env:USERPROFILE, "\configurations\environments")),
    [Parameter(Mandatory)]
    [string]
    $environment,
    [Parameter(Mandatory=$false)]
    [string]
    $location="North Europe",
    [Parameter(Mandatory)]
    [string]
    $module,
    [Parameter(Mandatory)]
    [string]
    $subscriptionId
)

# Set environment and namespace from provided environment
$env = $environment.Split('-')[1]
$namespace=$environment.Split('-')[0]
$location_no_spaces = $location.Replace(" ", "-").ToLower()

# Global backend.tfvars content
$global_backend = @"
storage_account_name = "sthn37mgfywa7g4"
container_name       = "$($subscriptionId)-$($location_no_spaces)"
key                  = "$($module).tfstate"
"@

$global_variables = @"
location    = "$($location)"
"@

# Environment specific backend.tfvars content
$environment_backend = @"
storage_account_name = "sthn37mgfywa7g4"
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
If (Test-Path (-Join($root_modules_directory, '\Modules\', $module))){

    # Set environment variable
    $env:TF_MODULE_CODE=(-Join($root_modules_directory, '\Modules\', $module))

} Else {

    Write-Warning ('Cannot find the root module: {0} in {1}' -f $module, $root_modules_directory)
    break

}

# Check whether the location directory and module directory exist (if applicable) 
switch ($environment){

    'Global' {

        # Check whether the environment configuration directory exists
        If (Test-Path (-Join($environment_directory, '\', $subscriptionId))){

            If (-not (Test-Path (-Join($environment_directory, '\', $subscriptionId, '\', $location)))){

                New-Item -Path (-Join($environment_directory, '\', $subscriptionId)) -Name "$location" -ItemType Directory | Out-Null   
    
            }

            $env:TF_ENVIRONMENT_VARS=(-Join($environment_directory, '\', $subscriptionId, '\', $location))

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

            Write-Warning ('Cannot find the environment configuration directory: {0} in {1}' -f $subscriptionId, $environment_directory)
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

# Get access key from storage account
$ACCESS_KEY = Get-AzStorageAccountKey -ResourceGroupName (Get-AzResource -Name "sthn37mgfywa7g4").ResourceGroupName -Name "sthn37mgfywa7g4" | Where-Object {$_.KeyName -eq "key1"}

# Set environment variables for Terraform
$env:TF_ENVIRONMENT=$env
$env:TF_NAMESPACE=$namespace
$env:TF_MODULE=$module
$env:TF_DATA_DIR=(-Join($env:TF_ENVIRONMENT_VARS, '\.terraform'))
$env:ARM_SUBSCRIPTION_ID=$subscriptionId
$env:ARM_ACCESS_KEY=($ACCESS_KEY).Value

$subscriptionName = az account list --query "[? contains(id, '$env:ARM_SUBSCRIPTION_ID')].[name]" --output json | ConvertFrom-Json

Write-host ('')
Write-Host ('Terraform Environment configuration:') -ForegroundColor Yellow
Write-Host ('--------------------------------------------------------------') -ForegroundColor White
Write-Host ('Environment configuration path: {0}' -f $env:TF_ENVIRONMENT_VARS) -ForegroundColor Magenta
Write-Host ('Terraform deployment path: {0}' -f $env:TF_MODULE_CODE) -ForegroundColor Magenta
Write-Host ('Terraform data path: {0}' -f $env:TF_DATA_DIR) -ForegroundColor Magenta
Write-Host ('Azure Subscription Name: {0}' -f $subscriptionName) -ForegroundColor Magenta