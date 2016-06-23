        [CmdletBinding()]            
param            
(                
    [ValidateNotNull()]            
    [System.Collections.ObjectModel.KeyedCollection [string,Microsoft.MetadirectoryServices.ConfigParameter]] $ConfigParameters,            
            
    [System.Management.Automation.PSCredential] $PSCredential,            
            
    [System.Collections.Generic.IList[Microsoft.MetaDirectoryServices.CSEntryChange]] $CSEntries,            
                
    [Microsoft.MetadirectoryServices.OpenExportConnectionRunStep] $OpenExportConnectionRunStep,            
            
    [Microsoft.MetadirectoryServices.Schema] $Schema            
)            
            
Set-StrictMode -Version 3.0

Import-Module (Join-Path -Path ([Microsoft.MetadirectoryServices.MAUtils]::MAFolder) -ChildPath 'FIMPowerShellConnectorModule.psm1') -Verbose:$false 
Import-Module 'C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.UserProfiles.dll'
Import-Module 'C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll'

foreach ($ConfigParameter in $ConfigParameters)
	{
		if ($ConfigParameter.Name -eq 'Server'){$Server = $ConfigParameter.Value.ToString()}
		if ($ConfigParameter.Name -eq 'Domain'){$Domain = $ConfigParameter.Value.ToString()}
	}

$exportResults = New-Object Microsoft.MetadirectoryServices.PutExportEntriesResults

$username = $PSCredential.UserName
$SecurePassword = $PSCredential.Password

# connect/authenticate to SharePoint Online and get ClientContext object..
$clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($Server) 
$credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username, $securePassword) 
$clientContext.Credentials = $credentials

$people = New-Object Microsoft.SharePoint.Client.UserProfiles.PeopleManager($clientContext)
             
foreach($CSEntry in $CSEntries) 
{          
    switch ($CSEntry.ObjectType) 
    {            
        'user' 
        {	  
            $guid = $CSEntry.Identifier        
            switch ($CSEntry.ObjectModificationType)
            {            
                'Add'
                {  
				}
				'Delete'
                {  
				}
				'Replace'
                {  
					foreach ($ChangedAttribute in $CSEntry.ChangedAttributeNames)
						{
							if ($ChangedAttribute -eq 'AboutMe'){$AboutMe = $CSEntry.AttributeChanges['AboutMe'].ValueChanges[0].Value.ToString()}
							if ($ChangedAttribute -eq 'CellPhone'){$CellPhone = $CSEntry.AttributeChanges['CellPhone'].ValueChanges[0].Value.ToString()}
							if ($ChangedAttribute -eq 'Department'){$Department = $CSEntry.AttributeChanges['Department'].ValueChanges[0].Value.ToString()}
							if ($ChangedAttribute -eq 'FirstName'){$FirstName = $CSEntry.AttributeChanges['FirstName'].ValueChanges[0].Value.ToString()}
							if ($ChangedAttribute -eq 'HomePhone'){$HomePhone = $CSEntry.AttributeChanges['HomePhone'].ValueChanges[0].Value.ToString()}
							if ($ChangedAttribute -eq 'LastName'){$LastName = $CSEntry.AttributeChanges['LastName'].ValueChanges[0].Value.ToString()}
							if ($ChangedAttribute -eq 'Manager'){$Manager = $CSEntry.AttributeChanges['Manager'].ValueChanges[0].Value.ToString()}
							if ($ChangedAttribute -eq 'Office'){$Office = $CSEntry.AttributeChanges['Office'].ValueChanges[0].Value.ToString()}
							if ($ChangedAttribute -eq 'PersonalSpace'){$PersonalSpace = $CSEntry.AttributeChanges['PersonalSpace'].ValueChanges[0].Value.ToString()}
							if ($ChangedAttribute -eq 'PictureURL'){$PictureURL = $CSEntry.AttributeChanges['PictureURL'].ValueChanges[0].Value.ToString()}
							if ($ChangedAttribute -eq 'PreferredName'){$PreferredName = $CSEntry.AttributeChanges['PreferredName'].ValueChanges[0].Value.ToString()}
							if ($ChangedAttribute -eq 'SPS-Department'){$SPSDepartment = $CSEntry.AttributeChanges['SPS-Department'].ValueChanges[0].Value.ToString()}
							if ($ChangedAttribute -eq 'SPS-JobTitle'){$SPSJobTitle = $CSEntry.AttributeChanges['SPS-JobTitle'].ValueChanges[0].Value.ToString()}
							if ($ChangedAttribute -eq 'SPS-Location'){$SPSLocation = $CSEntry.AttributeChanges['SPS-Location'].ValueChanges[0].Value.ToString()}
							if ($ChangedAttribute -eq 'SPS-UserPrincipalName'){$SPSUserPrincipalName = $CSEntry.AttributeChanges['SPS-UserPrincipalName'].ValueChanges[0].Value.ToString()}
							if ($ChangedAttribute -eq 'Title'){$Title = $CSEntry.AttributeChanges['Title'].ValueChanges[0].Value.ToString()}
							if ($ChangedAttribute -eq 'WorkEmail'){$WorkEmail = $CSEntry.AttributeChanges['WorkEmail'].ValueChanges[0].Value.ToString()}
							if ($ChangedAttribute -eq 'WorkPhone'){$WorkPhone = $CSEntry.AttributeChanges['WorkPhone'].ValueChanges[0].Value.ToString()}
						}
					$SPSAccountName = $CSEntry.AttributeChanges['AccountName'].ValueChanges[0].Value.ToString()
                    $csentryChangeResult = [Microsoft.MetadirectoryServices.CSEntryChangeResult]::Create($guid, $null, [Microsoft.MetadirectoryServices.MAExportError]::Success)
					
					$targetAccount = $SPSAccountName
					$myprofile = $people.GetPropertiesFor($targetAccount)
					$clientContext.Load($myprofile)
					$clientContext.ExecuteQuery()
            
					# Process our updates
					if ($AboutMe) {$people.SetSingleValueProfileProperty($targetAccount, 'AboutMe', $AboutMe)}
					if ($AccountName) {$people.SetSingleValueProfileProperty($targetAccount, 'AccountName', $AccountName)}
					if ($CellPhone) {$people.SetSingleValueProfileProperty($targetAccount, 'CellPhone', $CellPhone)}
					if ($Department) {$people.SetSingleValueProfileProperty($targetAccount, 'Department', $Department)}
					if ($FirstName) {$people.SetSingleValueProfileProperty($targetAccount, 'FirstName', $FirstName)}
					if ($HomePhone) {$people.SetSingleValueProfileProperty($targetAccount, 'HomePhone', $HomePhone)}
					if ($LastName) {$people.SetSingleValueProfileProperty($targetAccount, 'LastName', $LastName)}
					if ($Manager) {$people.SetSingleValueProfileProperty($targetAccount, 'Manager', $Manager)}
					if ($Office) {$people.SetSingleValueProfileProperty($targetAccount, 'Office', $Office)}
					if ($PersonalSpace) {$people.SetSingleValueProfileProperty($targetAccount, 'PersonalSpace', $PersonalSpace)}
					if ($PictureURL) {$people.SetSingleValueProfileProperty($targetAccount, 'PictureURL', $PictureURL)}
					if ($PreferredName) {$people.SetSingleValueProfileProperty($targetAccount, 'PreferredName', $PreferredName)}
					if ($SPSDepartment) {$people.SetSingleValueProfileProperty($targetAccount, 'SPS-Department', $SPSDepartment)}
					if ($SPSJobTitle) {$people.SetSingleValueProfileProperty($targetAccount, 'SPS-JobTitle', $SPSJobTitle)}
					if ($SPSLocation) {$people.SetSingleValueProfileProperty($targetAccount, 'SPS-Location', $SPSLocation)}
					if ($SPSUserPrincipalName) {$people.SetSingleValueProfileProperty($targetAccount, 'SPS-UserPrincipalName', $SPSUserPrincipalName)}
					if ($Title) {$people.SetSingleValueProfileProperty($targetAccount, 'Title', $Title)}
					if ($WorkEmail) {$people.SetSingleValueProfileProperty($targetAccount, 'WorkEmail', $WorkEmail)}
					if ($WorkPhone) {$people.SetSingleValueProfileProperty($targetAccount, 'WorkPhone', $WorkPhone)}
					
					$clientContext.ExecuteQuery()
					$exportResults.CSEntryChangeResults.Add($csentryChangeResult)
			
				}
				'Update'
                {  
				}
				default  
                {
                    $csentryChangeResult = [Microsoft.MetadirectoryServices.CSEntryChangeResult]::Create($guid, $null, [Microsoft.MetadirectoryServices.MAExportError]::Success)
                    $exportResults.CSEntryChangeResults.Add($csentryChangeResult)
                } 
            }         
         }            
    }  
 } 
 
Write-Output $exportResults