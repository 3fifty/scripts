## Synopsis
Script for generating Markdown documentation based on the information supplied within ARM Templates


```PowerShell
 D:\source\github-3fifty\scripts\02-New-MDARMTemplates\New-MDARMTemplates.ps1
```


## Information
**Version:**         1.0.0

**Author:**          3fifty

**Creation Date:**   31-01-2021

**Purpose/Change:**  New setup for community

**1.2.0:** 



## Description
All ARM templates have to follow the standard conventions. Based on the standard convention the markdown files are generated and saved within the target folder.


## Examples


###  Example 1 
```PowerShell
 .\New-MDARMTemplates.ps1 -TemplateFolder "C:\templates\" -OutputFolder "C:\markdown\" -KeepStructure $true 
```
## Parameters
### TemplateFolder
The folder that contains the ARM Templates
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


