<#
.SYNOPSIS
    Script for running local validation and tests

.DESCRIPTION
    Running scripts that are created locally for testing

.EXAMPLE
    .\LocalRun.ps1

.NOTES
    Version:        1.0.1;
    Author:         3fifty;
    Creation Date:  20-04-2020;
    Purpose/Change: New script setup;
#>
BEGIN {
    Write-Host "## Starting the local run." -ForegroundColor DarkBlue
}
PROCESS {
    Write-Host "## Processing the local PowerShell script and there operation" -ForegroundColor Green

    Write-Host "### Invoke new Markdown documentation - scripts" -ForegroundColor Blue
    ./01-New-MDPowerShellScripts/New-MDPowerShellScripts.ps1 -ScriptFolder "./" -OutputFolder "docs\powershell\" -KeepStructure $true -ExcludeFolder ".local,test-templates"

    #Write-Host "### Invoke new Markdown documentation - scripts" -ForegroundColor Blue
    ./02-New-MDARMTemplates/New-MDARMTemplates.ps1 -TemplateFolder "test-templates" -OutputFolder "docs\arm" 
}
END {
    Write-Host "## Ending the local run" -ForegroundColor DarkBlue
}