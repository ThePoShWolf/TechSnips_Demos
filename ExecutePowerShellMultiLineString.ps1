#region demo
Throw "This is a demo, dummy!"
#endregion
#region clean
Function Prompt(){}
Clear-Host
$proc = $null
$multiLineCommand = $null
$multiLineScriptBlock = $null
#endregion

#region multi line
$proc = Get-Process PowerShell
If($proc.Count -gt 1){
    Write-Output "There are $($proc.count) PowerShell consoles running!"
}ElseIf($proc.Count -eq 1){
    Write-Output "There is only one PowerShell console running!"
}Else{
    Write-Output "There are no PowerShell consoles running!"
}
$multiLineCommand = @'
$proc = Get-Process PowerShell
If($proc.Count -gt 1){
    Write-Output "There are $($proc.count) PowerShell consoles running!"
}ElseIf($proc.Count -eq 1){
    Write-Output "There is only one PowerShell console running!"
}Else{
    Write-Output "There are no PowerShell consoles running!"
}
'@
($multiLineCommand | Get-Member).TypeName[0]
$multiLineCommand

#region spoiler
$multiLineScriptBlock = [scriptblock]::Create($multiLine)
Invoke-Command -ScriptBlock $multiLineScriptBlock
#endregion
#endregion