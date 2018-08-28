#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region Find the information
#Lock out event ID
$LockoutID = 4740

#Lockouts will always happen on the PDC
(Get-ADDomain).PDCEmulator

#So all we have to do is to query the PDC logs?
$PDCEmulator = (Get-ADDomain).PDCEmulator
Get-WinEvent -ComputerName $PDCEmulator -FilterHashtable @{
    LogName = 'Security'
    ID = $LockoutID
}

#endregion