$website="demo"
$resourceGroupName = "demo-webjobs-resource-group"
$webAppName = "demo"
$Apiversion = 2015-08-01

 

function Get-PublishingProfileCredentials($resourceGroupName, $webAppName){

 


$resourceType = "Microsoft.Web/sites/config"
$resourceName = "$webAppName/publishingcredentials"
$publishingCredentials = Invoke-AzResourceAction -ResourceGroupName demo-webjobs-resource-group -ResourceType Microsoft.Web/sites/config -ResourceName demo/publishingcredentials -Action list -ApiVersion 2015-08-01 -Force
  return $publishingCredentials
}

 


function Get-KuduApiAuthorisationHeaderValue($resourceGroupName, $webAppName){
 
$publishingCredentials = Get-PublishingProfileCredentials $resourceGroupName $webAppName
return ("Basic {0}" -f [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f 
$publishingCredentials.Properties.PublishingUserName, $publishingCredentials.Properties.PublishingPassword))))
}
 

 


$accessToken = Get-KuduApiAuthorisationHeaderValue $resourceGroupName $webAppname

 

$Header = @{
'Content-Disposition'='attachment; attachment; filename=demo.zip'
'Authorization'=$accessToken
        }

 

$apiBaseUrl = "https://demo.scm.azurewebsites.net/api/"

 

$apiUrl = "https://demo.scm.azurewebsites.net/api/triggeredwebjobs/ScheduledJob"

 

$result = Invoke-RestMethod -Uri "$apiUrl" -Headers $Header -Method put -InFile "./demo.zip" -ContentType 'application/zip' 

 
