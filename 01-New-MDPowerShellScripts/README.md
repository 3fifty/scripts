The PowerShell script documentation generation is based on a script our product team found somewhere on Github. We adopted the idea and based on that we created our own. The documentation it self is generated based on the Help that is provided in the file.

```PowerShell
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
    Author:         3fifty | Maik van der Gaag | Leon Boers;
    Creation Date:  20-04-2020;
    Purpose/Change: Initial script development;

.EXAMPLE
    .\New-MDPowerShellScripts.ps1 -ScriptFolder "./" -OutputFolder "docs/arm"  -ExcludeFolder ".local,test-templates" -KeepStructure $true -IncludeWikiTOC $false
.EXAMPLE
    .\New-MDPowerShellScripts.ps1 -ScriptFolder "./" -OutputFolder "docs/arm"
#>
```
For the "Notes" field we use a specific specification in order to create a specific output. 

* [Name]: [Value];


## Synopsis
Script for generating Markdown documentation based on information in PowerShell script files.

```PowerShell
 D:\source\github-3fifty\scripts\01-New-MDPowerShellScripts\New-MDPowerShellScripts.ps1
```


## Information
**Version:**         1.0.0

**Author:**          3fifty | Maik van der Gaag | Leon Boers

**Creation Date:**   20-04-2020

**Purpose/Change:**  Initial script development



## Description
All PowerShell script files have synopsis attached on the document. With this script markdown files are generated and saved within the target folder.


## Examples


###  Example 1 
```PowerShell
 .\New-MDPowerShellScripts.ps1 -ScriptFolder "./" -OutputFolder "docs/arm"  -ExcludeFolder ".local,test-templates" -KeepStructure $true -IncludeWikiTOC $false 
```
###  Example 2 
```PowerShell
 .\New-MDPowerShellScripts.ps1 -ScriptFolder "./" -OutputFolder "docs/arm" 
```
## Parameters
### ScriptFolder
The folder that contains the scripts
| | |
|-|-|
| Type: | String |
| ParameterValue : | String|
| PipelineInput : | false|
| Position : | 1|
| Required : | true|


### OutputFolder
The folder were to safe the markdown files
| | |
|-|-|
| Type: | String |
| ParameterValue : | String|
| PipelineInput : | false|
| Position : | 2|
| Required : | true|


### ExcludeFolders
Exclude folder for generation. This is a comma seperated list
| | |
|-|-|
| Type: | String |
| ParameterValue : | String|
| PipelineInput : | false|
| Position : | 3|
| Required : | false|


### KeepStructure
Specified to keep the structure of the subfolders
| | |
|-|-|
| Type: | Boolean |
| DefaultValue : | False|
| ParameterValue : | Boolean|
| PipelineInput : | false|
| Position : | 4|
| Required : | false|


### IncludeWikiTOC
Include the TOC from the Azure DevOps wiki to the markdown files
| | |
|-|-|
| Type: | Boolean |
| DefaultValue : | False|
| ParameterValue : | Boolean|
| PipelineInput : | false|
| Position : | 5|
| Required : | false|


