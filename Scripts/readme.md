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
