#region demo
Throw "This is a demo, dummy!"
#endregion
#region clean
Function Prompt(){}
Clear-Host
$singleCommand = $multiLine = $null
$multiLineScriptBlock = $null
#endregion

#region multi line
$proc = Get-Process PowerShell
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

#region spoiler
$multiLineScriptBlock = [scriptblock]::Create($multiLine)
Invoke-Command -ScriptBlock $multiLineScriptBlock
#endregion
#endregion