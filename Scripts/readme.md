# Using the helper scripts with Terraform.

## PowerShell Profile

The helper scripts are aliased to make running scripts simpler. The alias mysource should be the root of the your Git repo, in my example my repo has been 
cloned to `c:\users\username\source`

```Powershell
# Functions related to aliases
function fnMySource {
        Set-Location (-join($env:USERPROFILE, '\Source\Terraform'))
}

# Alias commands
Set-Alias -Name mysource -Value fnMySource
Set-Alias -Name tfremstate -Value .\scripts\remoteState.ps1
Set-Alias -Name tfauth -Value .\scripts\auth.ps1
Set-Alias -Name tfset -Value .\scripts\setup.ps1
Set-Alias -Name tfinit -Value .\scripts\init.ps1
Set-Alias -Name tfplan -Value .\scripts\plan.ps1
```


The first script to run is `remotestate.ps1`

You can either configure the `azuredeploy.parameters.json` within the Remote_State directory or pass inline parameters e.g.


Using the parameters.json
```Powershell
$remotestate = tfremstate
```

Using inline parameters
```Powershell
...
```

## State container per environment

```Powershell
createStateContainer.ps1 -resourceGroupName $remotestate.Outputs.storageAccount_Id.value.split('/')[4] -StorageAccount $remotestate.Outputs.storageAccount_Id.value.split('/')[8] -Container "Learning"
```
