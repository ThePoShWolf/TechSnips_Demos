#region demo
Throw "This is a demo, dummy!"
#endregion
#region clean
Function Prompt(){}
Clear-Host
$proc = $null
$multiLineScript = $null
$scriptBlock = $null
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
$multiLineScript = @'
$proc = Get-Process PowerShell
If($proc.Count -gt 1){
    Write-Output "There are $($proc.count) PowerShell consoles running!"
}ElseIf($proc.Count -eq 1){
    Write-Output "There is only one PowerShell console running!"
}Else{
    Write-Output "There are no PowerShell consoles running!"
}
'@
($multiLineScript | Get-Member).TypeName[0]
$multiLineScript

#region spoiler
$scriptBlock = [scriptblock]::Create($multiLineScript)
($scriptBlock | Get-Member).TypeName[0]
Invoke-Command -ScriptBlock $scriptBlock
#endregion
#endregion