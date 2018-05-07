#region demo
Throw "This is a demo, dummy!"
#endregion
#region clean
Function Prompt(){}
Clear-Host
$singleCommand = $arg = $null
#endregion

#region ampersand
Get-Process
$singleCommand = "Get-Process"
($singleCommand | Get-Member).TypeName[0]
$singleCommand

& $singleCommand

#region args
$arg = "PowerShell"
& $singleCommand $arg
#endregion
#endregion