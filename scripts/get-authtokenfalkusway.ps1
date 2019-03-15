#heres me trying to connect to azure for an identity

$AadModule = Get-Module -Name "AzureAD" -ListAvailable
$adal = Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
$adalforms = Join-Path $AadModule.ModuleBase "Microsoft.IdentityModel.Clients.ActiveDirectory.Platform.dll"
[System.Reflection.Assembly]::LoadFrom($adal) | Out-Null
[System.Reflection.Assembly]::LoadFrom($adalforms) | Out-Null
$clientId = "e3caae67-6dc9-492b-85b4-fdeadf7ab695"
$user="jason.burns@mercurypoc.onmicrosoft.com"
$redirectUri = "urn:ietf:wg:oauth:2.0:oob"
$resourceAppIdURI = "https://graph.microsoft.com"
$authority = "https://login.microsoftonline.com/mercurypoc.onmicrosoft.com"
$authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority
$platformParameters = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters" -ArgumentList "Auto"
$userId = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.UserIdentifier" -ArgumentList ($User, "OptionalDisplayableId")

#heres me asking for adminconsent for some extra permissions on your tenant
#$authResult = $authContext.AcquireTokenAsync($resourceAppIdURI,$clientId,$redirectUri,$platformParameters,$userId,"prompt=admin_consent").Result
$authResult = $authContext.AcquireTokenAsync($resourceAppIdURI,$clientId,$redirectUri,$platformParameters,$userId).Result
$authresult |Get-Member

#heres me creating the authheader for talking to graph
$authHeader = @{
    'Content-Type'='application/json'
    'Authorization'="Bearer " + $authResult.AccessToken
    'ExpiresOn'=$authResult.ExpiresOn
    }

#heres me talking to graph
    $baseurl="https://graph.microsoft.com/beta/deviceAppManagement/"
    $collectionpath="MobileApps"
    $uri="$baseurl$collectionpath"
    $response = Invoke-RestMethod $uri -Method Get -Headers $authHeader;
    $response |Format-List