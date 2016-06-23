         param( 
    [ValidateNotNull()]     
    [System.Collections.ObjectModel.KeyedCollection [string,Microsoft.MetadirectoryServices.ConfigParameter]] $ConfigParameters,  
    [Microsoft.MetadirectoryServices.Schema]
    [ValidateNotNull()]
    $Schema,
    [Microsoft.MetadirectoryServices.OpenImportConnectionRunStep]
    $OpenImportConnectionRunStep,
    [Microsoft.MetadirectoryServices.ImportRunStep]
    $GetImportEntriesRunStep,
   [System.Management.Automation.PSCredential] 
    $PSCredential
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

$importResults = New-FIMGetImportEntriesResults
$csEntries = New-FIMCSEntryChanges

$username = $PSCredential.UserName
$SecurePassword = $PSCredential.Password

# connect/authenticate to SharePoint Online and get ClientContext object..
$clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($Server) 
$credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username, $securePassword) 
$clientContext.Credentials = $credentials

#Fetch the users in Site Collection
$users = $clientContext.Web.SiteUsers
$clientContext.Load($users)
$clientContext.ExecuteQuery()
 
#Create an Object [People Manager] to retrieve profile information
$people = New-Object Microsoft.SharePoint.Client.UserProfiles.PeopleManager($clientContext)

ForEach($user in $users)
    {
        $userprofile = $people.GetPropertiesFor($user.LoginName)
        $clientContext.Load($userprofile)
        $clientContext.ExecuteQuery()
            
        $profileattributes = $UserProfile.UserProfileProperties | Select-object
                   
        #Only process the object if they are a full user
        if ($profileattributes.'msOnline-ObjectId')
        {
            $csEntry = New-FIMCSEntryChange -ObjectType 'user' -ModificationType Add
			$csEntry.AnchorAttributes.Add([Microsoft.MetadirectoryServices.AnchorAttribute]::Create('SPS-UserPrincipalName', $profileattributes.'SPS-UserPrincipalName')) 
			$csEntry.DN = $profileattributes.'SPS-UserPrincipalName'
			$csEntry.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeAdd('AboutMe', $profileattributes.AboutMe))
			$csEntry.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeAdd('AccountName', $profileattributes.AccountName))  
			$csEntry.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeAdd('CellPhone', $profileattributes.CellPhone))
			$csEntry.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeAdd('Department', $profileattributes.Department))
			$csEntry.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeAdd('FirstName', $profileattributes.FirstName))
			$csEntry.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeAdd('HomePhone', $profileattributes.HomePhone))
			$csEntry.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeAdd('LastName', $profileattributes.LastName))
			$csEntry.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeAdd('Manager', $profileattributes.Manager))
			$csEntry.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeAdd('Office', $profileattributes.Office))
			$csEntry.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeAdd('PersonalSpace', $profileattributes.PersonalSpace))
			$csEntry.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeAdd('PictureURL', $profileattributes.PictureURL))
			$csEntry.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeAdd('PreferredName', $profileattributes.PreferredName))
			$csEntry.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeAdd('SID',$profileattributes.SID))
			$csEntry.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeAdd('SPS-Department', $profileattributes.'SPS-Department')) 
			$csEntry.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeAdd('SPS-JobTitle', $profileattributes.'SPS-JobTitle'))
			$csEntry.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeAdd('SPS-Location', $profileattributes.'SPS-Location'))
			$csEntry.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeAdd('Title', $profileattributes.Title))
			$csEntry.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeAdd('WorkEmail', $profileattributes.WorkEmail))
			$csEntry.AttributeChanges.Add([Microsoft.MetadirectoryServices.AttributeChange]::CreateAttributeAdd('WorkPhone', $profileattributes.WorkPhone))
			$csEntries.Add($csEntry)
        }
    }

$importResults.MoreToImport = $false
$importResults.CSEntries = $csEntries

Write-Output $importResults

$count=$users.Count

Write-Error "User Count is: $count" 
