<#
.SYNOPSIS
    Generates a Terraform plan using tfvars found in $env:TF_ENVIRONMENT_VARS

.NOTES
    Version:        1.0.0.0
    Author:         Dom Clayton
    Creation Date:  07/04/2022
    

.EXAMPLE
    plan.ps1
#>

If ((Test-Path env:TF_ENVIRONMENT_VARS) -and (Test-Path env:TF_MODULE_CODE)){

    if ($env:TF_NAMESPACE -eq "global"){

        $tfvars = (-Join($env:TF_ENVIRONMENT_VARS, '\', $env:TF_NAMESPACE,'.tfvars'))
        $plan = (-Join($env:TF_ENVIRONMENT_VARS, '\plans\', $env:TF_NAMESPACE.ToLower(), '_', (Get-Date).Day, (Get-Date).Month, (Get-Date).Year, (Get-Date).Hour, (Get-Date).Minute, '.plan'))

    } Else {

        $tfvars = (-Join($env:TF_ENVIRONMENT_VARS, '\', $env:TF_NAMESPACE, '-', $env:TF_ENVIRONMENT.ToLower(), '.tfvars'))
        $plan = (-Join($env:TF_ENVIRONMENT_VARS, '\plans\',  $env:TF_NAMESPACE, '-', $env:TF_ENVIRONMENT.ToLower(), '_', (Get-Date).Day, (Get-Date).Month, (Get-Date).Year, (Get-Date).Hour, (Get-Date).Minute, '.plan'))
    }

    Write-Host ('')
    Write-Host ('Planning module {0} using {1}' -f $env:TF_MODULE, $tfvars) -ForegroundColor Green  

    If (-not (Test-Path (-Join($env:TF_ENVIRONMENT_VARS, '\plans\')))){

        # Create Plans directory
        New-Item -Path $env:TF_ENVIRONMENT_VARS -Name 'Plans' -ItemType Directory | Out-Null

    }
    
    terraform -chdir="$env:TF_MODULE_CODE" plan -var-file="$tfvars" -out="$plan" -detailed-exitcode -compact-warnings

    Write-Host ('')
    Write-Host ('Saving plan as {0}' -f $plan) -ForegroundColor Magenta
    Write-Host ('Running tfapply will run: terraform -chdir="$env:TF_MODULE_CODE" apply "{0}"' -f $plan) -ForegroundColor Green

    
} Else {

    Write-Warning ('$env:TF_ENVIRONMENT_VARS and or $env:TF_MODULE_CODE have not been set. Please run tfset')

}