#region demo
Throw "This is a demo, dummy!"
#endregion
#region clean
Function Prompt(){}
Clear-Host
$singleCommand = $singleLine = $null
#endregion

#region ampersand
Get-Process
$singleCommand = "Get-Process"
$singleCommand

#region spoiler
& $singleCommand
#endregion
#region limitations
$singleLine = "Get-Process -Name PowerShell"
& $singleLine
#endregion
#endregion