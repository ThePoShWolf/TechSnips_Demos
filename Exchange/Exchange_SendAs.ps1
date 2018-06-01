#region demo header
Throw 'This is a demo, dummy!'
#endregion

#region prep
. 'C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto -ClientApplication:ManagementShell
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region demo

#Get the current send-as permission for a user
Get-ADPermission -Identity Sales | Where-Object {$_.IsInherited -eq $false -and $_.ExtendedRights -like "*Send-As*"} | Format-Table User,ExtendedRights

#Get the current send-as permission for a distribution group
Get-DistributionGroup -Identity Test2 | Select-Object GrantSendOnBehalfTo

#set for user

#set for distribution group

#endregion