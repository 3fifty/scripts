<#
.SYNOPSIS
    Script for generating Markdown documentation based on the information supplied within ARM Templates

.DESCRIPTION
    All ARM templates have to follow the standard conventions. Based on the standard convention the markdown files are generated and saved within the target folder.

.PARAMETER TemplateFolder
    The folder that contains the ARM Templates

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
    Creation Date:  31-01-2021;
    Purpose/Change: New setup for community;

.EXAMPLE
    .\New-MDARMTemplates.ps1 -TemplateFolder "C:\templates\" -OutputFolder "C:\markdown\" -KeepStructure $true
#>
[CmdletBinding()]

Param (
    [Parameter(Mandatory = $true, Position = 0)][string]$TemplateFolder,
    [Parameter(Mandatory = $true, Position = 1)][string]$OutputFolder,
    [Parameter(Mandatory = $false, Position = 2)][string]$ExcludeFolders,
    [Parameter(Mandatory = $false, Position = 3)][bool]$KeepStructure = $false,
    [Parameter(Mandatory = $false, Position = 4)][bool]$IncludeWikiTOC = $false
)


BEGIN {
    Write-Output ("TemplateFolder       : $($TemplateFolder)")
    Write-Output ("OutputFolder         : $($OutputFolder)")
    Write-Output ("ExcludeFolders       : $($ExcludeFolders)")
    Write-Output ("KeepStructure        : $($KeepStructure)")
    Write-Output ("IncludeWikiTOC       : $($IncludeWikiTOC)")

    $templateNameSuffix = ".md"
    $option = [System.StringSplitOptions]::RemoveEmptyEntries
    $exclude = $ExcludeFolders.Split(',', $option)
}
PROCESS {
    try {
        Write-Information ("Starting documentation generation for folder $($TemplateFolder)")

        if (!(Test-Path $OutputFolder)) {
            Write-Information ("Output path does not exists creating the folder: $($OutputFolder)")
            New-Item -ItemType Directory -Force -Path $OutputFolder
        }

        # Get the scripts from the folder
        $templates = Get-Childitem $TemplateFolder -Filter "*.json" -Recurse -Exclude "*parameters.json","*descriptions.json","*parameters.local.json"

        foreach ($template in $templates) {
            if (!$exclude.Contains($template.Directory.Name)) {
                Write-Information ("Documenting file: $($template.FullName)")

                if ($KeepStructure) {
                    if ($template.DirectoryName -ne $TemplateFolder) {
                        $newfolder = $OutputFolder + "/" + $template.Directory.Name
                        if (!(Test-Path $newfolder)) {
                            Write-Information ("Output folder for item does not exists creating the folder: $($newfolder)")
                            New-Item -Path $OutputFolder -Name $template.Directory.Name -ItemType "directory"
                        }
                    }
                } else {
                    $newfolder = $OutputFolder
                }

                $templateContent = Get-Content $template.FullName -Raw -ErrorAction Stop
                $templateObject = ConvertFrom-Json $templateContent -ErrorAction Stop

                if (!$templateObject) {
                    Write-Error -Message ("ARM Template file is not a valid json, please review the template")
                } else {
                    $outputFile = ("$($newfolder)/$($template.BaseName)$($templateNameSuffix)")
                    Out-File -FilePath $outputFile
                    if ($IncludeWikiTOC) {
                        ("[[_TOC_]]`n") | Out-File -FilePath $outputFile
                        "`n" | Out-File -FilePath $outputFile -Append
                    }

                    if ((($templateObject | get-member).name) -match "metadata") {
                        if ((($templateObject.metadata | get-member).name) -match "Description") {
                            Write-Verbose ("Description found. Adding to parent page and top of the arm-template specific page")
                            ("## Description") | Out-File -FilePath $outputFile -Append
                            $templateObject.metadata.Description | Out-File -FilePath $outputFile -Append
                        }

                        ("## Information") | Out-File -FilePath $outputFile -Append
                        $metadataProperties = $templateObject.metadata | get-member | where-object MemberType -eq NoteProperty
                        foreach ($metadata in $metadataProperties.Name) {
                            switch ($metadata) {
                                "Description" {
                                    Write-Verbose ("already processed the description. skipping")
                                }
                                Default {
                                    ("`n") | Out-File -FilePath $outputFile -Append
                                    ("**$($metadata):** $($templateObject.metadata.$metadata)") | Out-File -FilePath $outputFile -Append
                                }
                            }
                        }
                    }

                    ("## Parameters") | Out-File -FilePath $outputFile -Append
                    # Create a Parameter List Table
                    $parameterHeader = "| Parameter Name | Parameter Type |Parameter Description | Parameter DefaultValue | Parameter AllowedValues |"
                    $parameterHeaderDivider = "| --- | --- | --- | --- | --- | "
                    $parameterRow = " | {0}| {1} | {2} | {3} | {4} |"

                    $StringBuilderParameter = @()
                    $StringBuilderParameter += $parameterHeader
                    $StringBuilderParameter += $parameterHeaderDivider

                    $StringBuilderParameter += $templateObject.parameters | get-member -MemberType NoteProperty | ForEach-Object { $parameterRow -f $_.Name , $templateObject.parameters.($_.Name).type , $templateObject.parameters.($_.Name).metadata.description, $templateObject.parameters.($_.Name).defaultValue , (($templateObject.parameters.($_.Name).allowedValues) -join ',' )}
                    $StringBuilderParameter | Out-File -FilePath $outputFile -Append

                    ("## Resources") | Out-File -FilePath $outputFile -Append
                    # Create a Resource List Table
                    $resourceHeader = "| Resource Name | Resource Type | Resource Comment |"
                    $resourceHeaderDivider = "| --- | --- | --- | "
                    $resourceRow = " | {0}| {1} | {2} | "

                    $StringBuilderResource = @()
                    $StringBuilderResource += $resourceHeader
                    $StringBuilderResource += $resourceHeaderDivider

                    $StringBuilderResource += $templateObject.resources | ForEach-Object { $resourceRow -f $_.Name, $_.Type, $_.Comments }
                    $StringBuilderResource | Out-File -FilePath $outputFile -Append


                    if ((($templateObject | get-member).name) -match "outputs") {
                        write-verbose ("Output objects found.")
                        if (Get-Member -InputObject $templateObject.outputs -MemberType 'NoteProperty') {
                            ("## Outputs") | Out-File -FilePath $outputFile -Append
                            # Create an Output List Table
                            $outputHeader = "| Output Name | Output Type | Output Value |"
                            $outputHeaderDivider = "| --- | --- | --- |  "
                            $outputRow = " | {0}| {1} | {2} | "

                            $StringBuilderOutput = @()
                            $StringBuilderOutput += $outputHeader
                            $StringBuilderOutput += $outputHeaderDivider

                            $StringBuilderOutput += $templateObject.outputs | get-member -MemberType NoteProperty | ForEach-Object { $outputRow -f $_.Name , $templateObject.outputs.($_.Name).type , $templateObject.outputs.($_.Name).value }
                            $StringBuilderOutput | Out-File -FilePath $outputFile -Append
                        }
                    } else {
                        write-verbose ("This file does not contain outputs")
                    }
                }
            }
        }
    } catch {
        Write-Error "Something went wrong while generating the output documentation: $_"
    }
}
END {}
