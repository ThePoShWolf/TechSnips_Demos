$singleLine = "Get-Process"
#& $singleLine
$multiLine = @'
$proc = Get-Process PowerShell
If($proc.Count){
    Write-Output "There are $($proc.count) PowerShell consoles running!"
}
'@

#& $multiLine
$multiLineScriptBlock = [scriptblock]::Create($multiLine)
Invoke-Command -ScriptBlock $multiLineScriptBlock