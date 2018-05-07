#region demo
Throw "This is a demo, dummy!"
#endregion
#region clean
Function Prompt(){}
Clear-Host
$singleCommand = $multiLine = $null
$multiLineScriptBlock = $null
#endregion

#region ampersand
Get-Process
$singleCommand = "Get-Process"
$singleCommand

#region spoiler
& $singleCommand
#endregion
#endregion