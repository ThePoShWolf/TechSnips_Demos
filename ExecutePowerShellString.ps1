#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
$singleLine = $multiLine = $null
$multiLineScriptBlock = $null
#endregion

#region single line
$singleLine = "Get-Process"
& $singleLine
#endregion

#region multi line
$multiLine = @'
$proc = Get-Process PowerShell
If($proc.Count){
    Write-Output "There are $($proc.count) PowerShell consoles running!"
}
'@
& $multiLine

#region spoiler
$multiLineScriptBlock = [scriptblock]::Create($multiLine)
Invoke-Command -ScriptBlock $multiLineScriptBlock
#endregion
#endregion