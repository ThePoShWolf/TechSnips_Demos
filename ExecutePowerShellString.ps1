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
$singleCommand

& $singleCommand

#region args
$arg = "PowerShell"
& $singleCommand $arg
#endregion
#endregion