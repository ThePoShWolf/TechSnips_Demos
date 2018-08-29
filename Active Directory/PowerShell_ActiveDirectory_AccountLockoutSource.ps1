#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region

#Account lockout Event ID
$LockOutID = 4740

#Find the PDC
(Get-ADDomain).PDCEmulator
$PDCEmulator = (Get-ADDomain).PDCEmulator

#Query event log
Get-WinEvent -ComputerName $PDCEmulator -FilterHashtable @{
    LogName = 'Security'
    ID = $LockOutID
}


#endregion