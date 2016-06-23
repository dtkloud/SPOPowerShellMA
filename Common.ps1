 Set-StrictMode -Version 3.0
           
function New-FIMSchema {            
    [CmdletBinding()]            
    [OutputType([Microsoft.MetadirectoryServices.Schema])]            
    param()            
            
    [Microsoft.MetadirectoryServices.Schema]::Create()            
}            
            
function New-FIMSchemaType            
{            
    [CmdletBinding()]            
    [OutputType([Microsoft.MetadirectoryServices.SchemaType])]            
    param            
    (            
        [ValidateNotNullOrEmpty()]            
        [string] $Name,            
        [switch] $LockAnchorAttributeDefinition            
    )            
            
    [Microsoft.MetadirectoryServices.SchemaType]::Create($Name, $LockAnchorAttributeDefinition.ToBool())            
}            
            
function Add-FIMSchemaAttribute            
{            
    [CmdletBinding(DefaultParameterSetName = 'SingleValued')]            
    [OutputType([Microsoft.MetadirectoryServices.SchemaAttribute])]            
    param            
    (            
        [Parameter(Mandatory=$True, ValueFromPipeline)]            
        [ValidateNotNull()]            
        [Microsoft.MetadirectoryServices.SchemaType] $InputObject,            
            
        [Parameter(Mandatory=$True, ParameterSetName='Anchor')]            
        [Parameter(Mandatory=$True, ParameterSetName = 'MultiValued')]            
        [Parameter(Mandatory=$True, ParameterSetName = 'SingleValued')]            
        [ValidateNotNullOrEmpty()]            
        [string] $Name,            
            
        [Parameter(ParameterSetName='Anchor')]            
        [switch] $Anchor,            
            
        [Parameter(ParameterSetName = 'MultiValued')]            
        [switch] $Multivalued,            
            
        [Parameter(Mandatory=$True, ParameterSetName='Anchor')]            
        [Parameter(Mandatory=$True, ParameterSetName = 'MultiValued')]            
        [Parameter(Mandatory=$True, ParameterSetName = 'SingleValued')]            
        [ValidateSet('Binary', 'Boolean', 'Integer', 'Reference', 'String')]            
        [string] $DataType,            
            
        [Parameter(Mandatory=$True, ParameterSetName='Anchor')]            
        [Parameter(Mandatory=$True, ParameterSetName = 'MultiValued')]            
        [Parameter(Mandatory=$True, ParameterSetName = 'SingleValued')]            
        [ValidateSet('ImportOnly', 'ExportOnly', 'ImportExport')]            
        [string] $SupportedOperation            
    )            
                
    switch ($PSCmdlet.ParameterSetName) {            
        'SingleValued' {            
            $InputObject.Attributes.Add([Microsoft.MetadirectoryServices.SchemaAttribute]::CreateSingleValuedAttribute($Name, $DataType, $SupportedOperation))            
        }            
            
        'MultiValued' {            
            if ($Multivalued) {            
                $InputObject.Attributes.Add([Microsoft.MetadirectoryServices.SchemaAttribute]::CreateMultiValuedAttribute($Name, $DataType, $SupportedOperation))            
            } else {            
                $InputObject.Attributes.Add([Microsoft.MetadirectoryServices.SchemaAttribute]::CreateSingleValuedAttribute($Name, $DataType, $SupportedOperation))            
            }            
        }            
            
        'Anchor' {            
            if ($Anchor) {            
                $InputObject.Attributes.Add([Microsoft.MetadirectoryServices.SchemaAttribute]::CreateAnchorAttribute($Name, $DataType, $SupportedOperation))            
            } else {            
                $InputObject.Attributes.Add([Microsoft.MetadirectoryServices.SchemaAttribute]::CreateSingleValuedAttribute($Name, $DataType, $SupportedOperation))            
            }            
        }            
    }            
}            
            
function New-FIMCSEntryChange            
{            
    [CmdletBinding()]            
    [OutputType([Microsoft.MetadirectoryServices.CSEntryChange])]            
    param            
    (            
        [Parameter(Mandatory=$True)]            
        [ValidateNotNullOrEmpty()]            
        [string] $ObjectType,            
            
        [Parameter(Mandatory=$True)]            
        [ValidateSet('Add', 'Delete', 'Update', 'Replace', 'None')]            
        [string] $ModificationType,            
            
        [ValidateNotNullOrEmpty()]            
        [Alias('DistinguishedName')]            
        [string] $DN            
    )            
            
    $CSEntry = [Microsoft.MetadirectoryServices.CSEntryChange]::Create()            
    $CSEntry.ObjectModificationType = $ModificationType            
    $CSEntry.ObjectType = $ObjectType            
            
    if ($DN) {            
        $CSEntry.DN = $DN            
    }            
            
    $CSEntry            
}            
            
function Add-FIMCSAttributeChange            
{            
    [CmdletBinding(DefaultParameterSetName = 'Replace')]            
    param            
    (            
        [Parameter(Mandatory=$True, ValueFromPipeline, ParameterSetName='Add')]            
        [Parameter(Mandatory=$True, ValueFromPipeline, ParameterSetName='Update')]            
        [Parameter(Mandatory=$True, ValueFromPipeline, ParameterSetName='Delete')]            
        [Parameter(Mandatory=$True, ValueFromPipeline, ParameterSetName='Replace')]            
        [Parameter(Mandatory=$True, ValueFromPipeline, ParameterSetName='Rename')]            
        [ValidateNotNull()]            
        [Microsoft.MetadirectoryServices.CSEntryChange] $InputObject,            
            
        [Parameter(Mandatory=$True, ParameterSetName='Add')]            
        [switch] $Add,            
            
        [Parameter(Mandatory=$True, ParameterSetName='Update')]            
        [switch] $Update,            
            
        [Parameter(Mandatory=$True, ParameterSetName='Delete')]            
        [switch] $Delete,            
            
        [Parameter(Mandatory=$True, ParameterSetName='Replace')]            
        [switch] $Replace,            
            
        [Parameter(Mandatory=$True, ParameterSetName='Rename')]            
        [switch] $Rename,            
                    
        [Parameter(Mandatory=$True, ParameterSetName='Add')]            
        [Parameter(Mandatory=$True, ParameterSetName='Update')]            
        [Parameter(Mandatory=$True, ParameterSetName='Delete')]            
        [Parameter(Mandatory=$True, ParameterSetName='Replace')]            
        [ValidateNotNullOrEmpty()]            
        [string] $Name,            
            
        [Parameter(Mandatory=$True, ParameterSetName='Add')]            
        [Parameter(Mandatory=$True, ParameterSetName='Update')]            
        [Parameter(Mandatory=$True, ParameterSetName='Replace')]            
        [Parameter(Mandatory=$True, ParameterSetName='Rename')]            
        $Value,            
            
        [switch] $PassThru            
    )            
            
    process {            
        switch ($PSCmdlet.ParameterSetName) {            
            'Add' {            
                $InputObject.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeAdd($Name, $Value))            
            }            
            
            'Update' {            
                $InputObject.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeUpdate($Name, $Value))            
            }            
            
            'Delete' {            
                $InputObject.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeDelete($Name))            
            }            
            
            'Replace' {            
                $InputObject.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeReplace($Name, $Value))            
            }            
            
            'Rename' {            
                $InputObject.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateNewDN($Value))            
            }            
        }            
            
        if ($PassThru) {            
            $InputObject            
        }            
    }            
}            
            
function New-FIMPutExportEntriesResults            
{            
    [CmdletBinding()]            
    [OutputType([Microsoft.MetadirectoryServices.PutExportEntriesResults])]            
    param            
    (            
        [ValidateNotNullOrEmpty()]            
        [Microsoft.MetadirectoryServices.CSEntryChangeResult[]] $Results            
    )            
            
    if ($Results) {            
        New-Object Microsoft.MetadirectoryServices.PutExportEntriesResults (New-Object System.Collections.Generic.List[Microsoft.MetadirectoryServices.CSEntryChangeResult] (,$Results))            
    } else {            
        New-Object Microsoft.MetadirectoryServices.PutExportEntriesResults            
    }            
}            
            
function New-FIMCloseImportConnectionResults            
{            
    [CmdletBinding()]            
    [OutputType([Microsoft.MetadirectoryServices.CloseImportConnectionResults])]            
    param            
    (            
        [ValidateNotNullOrEmpty()]            
        [string] $CustomData            
    )            
            
    if ($CustomData) {            
        New-Object Microsoft.MetadirectoryServices.CloseImportConnectionResults $CustomData            
    } else {            
        New-Object Microsoft.MetadirectoryServices.CloseImportConnectionResults            
    }            
}            
            
function New-FIMOpenImportConnectionResults            
{            
    [CmdletBinding()]            
    [OutputType([Microsoft.MetadirectoryServices.OpenImportConnectionResults])]            
    param            
    (            
        [ValidateNotNullOrEmpty()]            
        [string] $CustomData            
    )            
            
    if ($CustomData) {            
        New-Object Microsoft.MetadirectoryServices.OpenImportConnectionResults $CustomData            
    } else {            
        New-Object Microsoft.MetadirectoryServices.OpenImportConnectionResults            
    }            
}            
            
function New-FIMCSEntryChanges            
{            
    [CmdletBinding()]            
    [OutputType([System.Collections.Generic.List[Microsoft.MetaDirectoryServices.CSEntryChange]])]            
    param()            
            
    New-Object System.Collections.Generic.List[Microsoft.MetaDirectoryServices.CSEntryChange]            
}            
            
function New-FIMGetImportEntriesResults            
{            
    [CmdletBinding()]            
    [OutputType([Microsoft.MetadirectoryServices.GetImportEntriesResults])]            
    param            
    (            
        [string] $CustomData,            
            
        [switch] $MoreToImport,            
            
        [System.Collections.Generic.List[Microsoft.MetaDirectoryServices.CSEntryChange]] $CSEntries            
    )            
            
    if ($CustomData -or $CSEntries -or $MoreToImport) {            
        New-Object Microsoft.MetadirectoryServices.GetImportEntriesResults $CustomData,$MoreToImport.ToBool(),($CSEntries)            
    } else {            
        New-Object Microsoft.MetadirectoryServices.GetImportEntriesResults            
    }            
}            

Export-ModuleMember -Function * -Verbose:$false -Debug:$false 
