Automatically documentation ARM templates is done via this script. The documentation is generated based on the information that is availible by default within the templates

To be able to have more information we use a property called "metadata" in this property the "Description" is used by default and the other properties can be filled in the way you like.

```json
"metadata": {
     "Description": "This template deploys a standard storage account.",
    "Author": "3fifty | Leon Boers | Maik van der Gaag",
    "Version": "1.0.0"
}
```

## Synopsis
Script for generating Markdown documentation based on the information supplied within ARM Templates


```PowerShell
 .\New-MDARMTemplates.ps1 [-TemplateFolder] <String> [-OutputFolder] <String> [[-ExcludeFolders] <String>] [[-KeepStructure] <Boolean>] [[-IncludeWikiTOC] <Boolean>] [<CommonParameters>]
```


## Information
**Version:**         1.0.0

**Author:**          3fifty | Maik van der Gaag | Leon Boers

**Creation Date:**   31-01-2021

**Purpose/Change:**  New setup for community


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


