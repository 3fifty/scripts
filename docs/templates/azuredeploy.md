## Description
This template deploys a standard storage account.
## Information


**Author:** 3fifty


**Version:** 1.0.0
## Parameters
| Parameter Name | Parameter Type |Parameter Description | Parameter DefaultValue | Parameter AllowedValues |
| --- | --- | --- | --- | --- | 
 | location| string | Location for all resources. | [resourceGroup().location] |  |
 | storageAccountType| string | Storage Account type | Standard_LRS | Standard_LRS,Standard_GRS,Standard_ZRS,Premium_LRS |
## Resources
| Resource Name | Resource Type | Resource Comment |
| --- | --- | --- | 
 | [variables('storageAccountName')]| Microsoft.Storage/storageAccounts |  | 
## Outputs
| Output Name | Output Type | Output Value |
| --- | --- | --- |  
 | storageAccountName| string | [variables('storageAccountName')] | 
