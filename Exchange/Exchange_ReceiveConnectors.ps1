#region demo header
Throw 'This is a demo, dummy!'


#region prep
. 'C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto -ClientApplication:ManagementShell
#endregion

#region clean
Remove-ReceiveConnector 'MFPs' -Confirm:$false
Remove-ReceiveConnector 'Internal Exchange' -Confirm:$false
Function Prompt(){}
Clear-Host
#endregion
#endregion 

Get-PSSession

#region Get all receive connectors
Get-ReceiveConnector

#endregion

#region Create Receive connectors
#New receive connector for internal Exchange Servers
$internalCon = @{
    Name = 'Internal Exchange'
    TransportRole = 'Frontend'
    Internal = $true
    RemoteIPRanges = '192.168.13.10','192.168.13.11','192.168.13.12'
}
New-ReceiveConnector @internalCon

#Validate
Get-ReceiveConnector


#New receive connector for internal devices
$devCon = @{
    Name = 'MFPs'
    Custom = $true
    Bindings = '0.0.0.0:25'
    RemoteIPRanges = '192.168.1.81'
    TransportRole = 'Frontend'
    PermissionGroups = 'AnonymousUsers'
}
New-ReceiveConnector @devCon

#Validate
Get-ReceiveConnector

#endregion

#region Edit connectors
#Get Remote IP Ranges
$rCon = Get-ReceiveConnector 'MFPs'
$rCon.RemoteIPRanges

#set
$devConChanges = @{
    Identity = 'MFPs'
    RemoteIPRanges = $rCon.RemoteIPRanges + '192.168.1.5','192.168.1.7'
}
Set-ReceiveConnector @devConChanges

#Connection timeout
Set-ReceiveConnector 'MFPs' -ConnectionTimeout 00:15:00

#endregion

#region Removing
#remove
Remove-ReceiveConnector 'MFPs'

#endregion