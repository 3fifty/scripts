<#
.SYNOPSIS
    Script for generating Markdown documentation based on information in PowerShell script files.

.DESCRIPTION
    All PowerShell script files have synopsis attached on the document. With this script markdown files are generated and saved within the target folder.

.PARAMETER ScriptFolder
    The folder that contains the scripts

.PARAMETER OutputFolder
    The folder were to safe the markdown files

.PARAMETER ExcludeFolders
    Exclude folder for generation. This is a comma seperated list

.PARAMETER KeepStructure
    Specified to keep the structure of the subfolders

.PARAMETER IncludeWikiTOC
Include the TOC from the Azure DevOps wiki to the markdown files

.NOTES
    Version:        1.0.0;
    Author:         3fifty;
    Creation Date:  20-04-2020;
    Purpose/Change: Initial script development;

.EXAMPLE
    .\New-MDPowerShellScripts.ps1 -ScriptFolder "./" -OutputFolder "docs/arm"  -ExcludeFolder ".local,test-templates" -KeepStructure $true -IncludeWikiTOC $false
.EXAMPLE
    .\New-MDPowerShellScripts.ps1 -ScriptFolder "./" -OutputFolder "docs/arm"
#>
[CmdletBinding()]

Param (
    [Parameter(Mandatory = $true, Position = 0)][string]$ScriptFolder,
    [Parameter(Mandatory = $true, Position = 1)][string]$OutputFolder,
    [Parameter(Mandatory = $false, Position = 2)][string]$ExcludeFolders,
    [Parameter(Mandatory = $false, Position = 3)][bool]$KeepStructure = $false,
    [Parameter(Mandatory = $false, Position = 4)][bool]$IncludeWikiTOC = $false
)

BEGIN {
    Write-Output ("ScriptFolder         : $($ScriptFolder)")
    Write-Output ("OutputFolder         : $($OutputFolder)")
    Write-Output ("ExcludeFolders       : $($ExcludeFolders)")
    Write-Output ("KeepStructure        : $($KeepStructure)")
    Write-Output ("IncludeWikiTOC       : $($IncludeWikiTOC)")

    $arrParameterProperties = @("DefaultValue", "ParameterValue", "PipelineInput", "Position", "Required")
    $scriptNameSuffix = ".md"
    $option = [System.StringSplitOptions]::RemoveEmptyEntries

    $exclude = $ExcludeFolders.Split(',', $option)

}
PROCESS {
    try {
        Write-Information ("Starting documentation generation for folder $($ScriptFolder)")

        if (!(Test-Path $OutputFolder)) {
            Write-Information ("Output path does not exists creating the folder: $($OutputFolder)")
            New-Item -ItemType Directory -Force -Path $OutputFolder
        }

        # Get the scripts from the folder
        $scripts = Get-Childitem $ScriptFolder -Filter "*.ps1" -Recurse

        foreach ($script in $scripts) {
            if (!$exclude.Contains($script.Directory.Name)) {
                Write-Information ("Documenting file: $($script.FullName)")


                if ($KeepStructure) {
                    if ($script.DirectoryName -ne $ScriptFolder) {
                        $newfolder = $OutputFolder + "/" + $script.Directory.Name
                        if (!(Test-Path $newfolder)) {
                            Write-Information ("Output folder for item does not exists creating the folder: $($newfolder)")
                            New-Item -Path $OutputFolder -Name $script.Directory.Name -ItemType "directory"
                        }
                    }
                } else {
                    $newfolder = $OutputFolder
                }

                $help = Get-Help $script.FullName -ErrorAction "SilentlyContinue" -Detailed

                if ($help) {
                    $outputFile = ("$($newfolder)/$($script.BaseName)$($scriptNameSuffix)")
                    Out-File -FilePath $outputFile

                    if ($IncludeWikiTOC) {
                        ("[[_TOC_]]`n") | Out-File -FilePath $outputFile
                        "`n" | Out-File -FilePath $outputFile -Append
                    }

                    #synopsis
                    if ($help.Synopsis) {
                        ("## Synopsis") | Out-File -FilePath $outputFile -Append
                        ("$($help.Synopsis)") | Out-File -FilePath $outputFile -Append
                        "`n" | Out-File -FilePath $outputFile -Append
                    } else {
                        Write-Warning -Message ("Synopsis not defined in file $($script.fullname)")
                    }

                    #syntax
                    if ($help.Syntax) {
                        ("``````PowerShell`n $($help.Syntax.syntaxItem.name)`n``````") | Out-File -FilePath $outputFile -Append
                        "`n" | Out-File -FilePath $outputFile -Append
                    } else {
                        Write-Warning -Message ("Syntax not defined in file $($script.fullname)")
                    }

                    #notes (seperated by (name): and (value);)
                    if ($help.alertSet) {
                        ("## Information") | Out-File -FilePath $outputFile -Append
                        $text = $help.alertSet.alert.Text.Split(';', $option)
                        foreach ($line in $text) {
                            $items = $line.Trim().Split(':', $option)
                            ("**$($items[0]):** $($items[1])`n") | Out-File -FilePath $outputFile -Append
                        }
                        "`n" | Out-File -FilePath $outputFile -Append
                    } else {
                        Write-Warning -Message ("Notes not defined in file $($script.fullname)")
                    }

                    #description
                    if ($help.Description) {
                        "## Description" | Out-File -FilePath $outputFile -Append
                        $help.Description.Text | Out-File -FilePath $outputFile -Append
                        "`n" | Out-File -FilePath $outputFile -Append
                    } else {
                        Write-Warning -Message "Description not defined in file $($script.fullname)"
                    }

                    #examples
                    if ($help.Examples) {
                        ("## Examples") | Out-File -FilePath $outputFile -Append
                        "`n" | Out-File -FilePath $outputFile -Append
                        forEach ($item in $help.Examples.Example) {
                            $title = $item.title.Replace("--------------------------", "").Replace("EXAMPLE", "Example")
                            ("### $($title)") | Out-File -FilePath $outputFile -Append
                            if ($item.Code) {
                                ("``````PowerShell`r`n $($item.Code) `r`n``````") | Out-File -FilePath $outputFile -Append
                            }
                        }
                    } else {
                        Write-Warning -Message "Examples not defined in file $($script.fullname)"
                    }

                    if ($help.Parameters) {
                        ("## Parameters") | Out-File -FilePath $outputFile -Append
                        forEach ($item in $help.Parameters.Parameter) {
                            ("### $($item.name)") | Out-File -FilePath $outputFile -Append
                            $item.description[0].text | Out-File -FilePath $outputFile -Append
                            ("| | |") | Out-File -FilePath $outputFile -Append
                            ("|-|-|") | Out-File -FilePath $outputFile -Append
                            ("| Type: | $($item.Type.Name) |") | Out-File -FilePath $outputFile -Append
                            foreach ($arrParameterProperty in $arrParameterProperties) {
                                if ($item.$arrParameterProperty) {
                                    ("| $arrParameterProperty : | $($item.$arrParameterProperty)|") | Out-File -FilePath $outputFile -Append
                                }
                            }
                            "`n" | Out-File -FilePath $outputFile -Append
                        }
                    } else {
                        Write-Warning -Message "Parameters not defined in file $($script.fullname)"
                    }

                } else {
                    Write-Error -Message ("Synopsis could not be found for script $($script.FullName)")
                }
            }
        }
    } catch {
        Write-Error "Something went wrong while generating the output documentation: $_"
    }
}
END {}