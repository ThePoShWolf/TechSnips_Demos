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
Get-Process PowerShell | Format-Table Name,Id
$singleLine = "Get-Process PowerShell | Format-Table Name,Id"
$singleLine
#region spoiler
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
& $multiLine

#region spoiler
$multiLineScriptBlock = [scriptblock]::Create($multiLine)
Invoke-Command -ScriptBlock $multiLineScriptBlock
#endregion
#endregion