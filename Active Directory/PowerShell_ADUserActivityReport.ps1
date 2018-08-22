#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region Getting started
#Event IDs to look for
#4648 is explicit logon, 4647 is logoff
$EventIds = 4647,4648

#Get those events from the security event log
Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    ID = $EventIds
}
#endregion

#region Parse the events for relevant data

$Events = Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    ID = $EventIds
}

$Events[0].Message

$Events[0].Properties

#Account
$Events[0].Properties[5].Value

#Event ID
$Events[0].ID

#Other Event ID
($Events | Where-Object ID -ne $Events[0].ID)[0].Message

#Account
($Events | Where-Object ID -ne $Events[0].ID)[0].Properties[1].Value

#endregion