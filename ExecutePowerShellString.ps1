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
#region single line
$singleLine = "Get-Process PowerShell"
& $singleLine
#endregion
#endregion

Clear-Host

#region multi line
Get-Process PowerShell
If($proc.Count){
    Write-Output "There are $($proc.count) PowerShell consoles running!"
}Else{
    Write-Output "There is only one PowerShell console running!"
}
$multiLine = @'
$proc = Get-Process PowerShell
If($proc.Count){
    Write-Output "There are $($proc.count) PowerShell consoles running!"
}Else{
    Write-Output "There is only one PowerShell console running!"
}
'@
$multiLine
& $multiLine

#region spoiler
$multiLineScriptBlock = [scriptblock]::Create($multiLine)
Invoke-Command -ScriptBlock $multiLineScriptBlock
#endregion
#endregion