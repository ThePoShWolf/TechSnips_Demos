#region demo header
Throw 'This is a demo, dummy!'
#endregion

#region prep
. 'C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto -ClientApplication:ManagementShell
#endregion

#region clean
Remove-ReceiveConnector 'Executive MFP' -Confirm:$false
Function Prompt(){}
Clear-Host
#endregion

#region demo

#Get all receive connectors
Get-ReceiveConnector

#New receive connector for SMTP gateway

#New receive connector for internal devices
$ReceiveConnector = @{
    'Name' = 'Executive MFP'
    'Custom' = $true
    'Bindings' = '0.0.0.0:25'
    'RemoteIPRanges' = '10.2.2.42'
    'TransportRole' = 'Frontend'
    'PermissionGroups' = 'AnonymousUsers'
}
New-ReceiveConnector @ReceiveConnector

#set

#remove

#endregion