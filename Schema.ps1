    [CmdletBinding()]            
param            
(                
    [System.Collections.ObjectModel.KeyedCollection[string,Microsoft.MetadirectoryServices.ConfigParameter]] $ConfigParameters,            
            
    [System.Management.Automation.PSCredential] $PSCredential            
)            
Set-StrictMode -Version 3.0                         
            
Import-Module (Join-Path -Path ([Environment]::GetEnvironmentVariable('TEMP', [EnvironmentVariableTarget]::Machine)) -ChildPath 'FIMPowerShellConnectorModule.psm1') -Verbose:$false            
            
$Schema = New-FIMSchema            
            
$SchemaType = New-FIMSchemaType -Name 'user'                
$SchemaType | Add-FIMSchemaAttribute -Name 'sourceAnchor' -Anchor -DataType 'String' -SupportedOperation ImportExport
$SchemaType | Add-FIMSchemaAttribute -Name 'AboutMe'  -DataType 'String' -SupportedOperation ImportExport
$SchemaType | Add-FIMSchemaAttribute -Name 'AccountName'  -DataType 'String' -SupportedOperation ImportExport
$SchemaType | Add-FIMSchemaAttribute -Name 'CellPhone'  -DataType 'String' -SupportedOperation ImportExport
$SchemaType | Add-FIMSchemaAttribute -Name 'Department'  -DataType 'String' -SupportedOperation ImportExport
$SchemaType | Add-FIMSchemaAttribute -Name 'FirstName'  -DataType 'String' -SupportedOperation ImportExport
$SchemaType | Add-FIMSchemaAttribute -Name 'HomePhone'  -DataType 'String' -SupportedOperation ImportExport
$SchemaType | Add-FIMSchemaAttribute -Name 'LastName'  -DataType 'String' -SupportedOperation ImportExport
$SchemaType | Add-FIMSchemaAttribute -Name 'Manager'  -DataType 'String' -SupportedOperation ImportExport
$SchemaType | Add-FIMSchemaAttribute -Name 'Office'  -DataType 'String' -SupportedOperation ImportExport
$SchemaType | Add-FIMSchemaAttribute -Name 'PersonalSpace'  -DataType 'String' -SupportedOperation ImportExport
$SchemaType | Add-FIMSchemaAttribute -Name 'PictureURL'  -DataType 'String' -SupportedOperation ImportExport
$SchemaType | Add-FIMSchemaAttribute -Name 'PreferredName'  -DataType 'String' -SupportedOperation ImportExport
$SchemaType | Add-FIMSchemaAttribute -Name 'SID'  -DataType 'String' -SupportedOperation ImportExport
$SchemaType | Add-FIMSchemaAttribute -Name 'SPS-Department'  -DataType 'String' -SupportedOperation ImportExport
$SchemaType | Add-FIMSchemaAttribute -Name 'SPS-JobTitle'  -DataType 'String' -SupportedOperation ImportExport
$SchemaType | Add-FIMSchemaAttribute -Name 'SPS-Location'  -DataType 'String' -SupportedOperation ImportExport
$SchemaType | Add-FIMSchemaAttribute -Name 'SPS-UserPrincipalName'  -DataType 'String' -SupportedOperation ImportExport
$SchemaType | Add-FIMSchemaAttribute -Name 'Title'  -DataType 'String' -SupportedOperation ImportExport
$SchemaType | Add-FIMSchemaAttribute -Name 'WorkEmail'  -DataType 'String' -SupportedOperation ImportExport
$SchemaType | Add-FIMSchemaAttribute -Name 'WorkPhone'  -DataType 'String' -SupportedOperation ImportExport

$Schema.Types.Add($SchemaType)                       
            
Write-Output $Schema