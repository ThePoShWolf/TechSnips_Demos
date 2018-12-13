# Path location
$env:Path

$env:Path.Split(';')

#region Adding
$env:Path += ';C:\tmp'

# Demonstration
Get-ChildItem 'C:\tmp'

executeme.ps1

New-Item C:\tmp\executeme.ps1 -Value "Write-Host 'Hello from executeme.ps1'"

Get-Location
executeme.ps1
#endregion

#region Removing
$env:Path.Split(';').Count

$env:Path = $env:path -replace "\;C\:\\tmp$",''

$env:Path = $env:Path -replace [regex]::Escape(';C:\Program Files (x86)\Common Files\Oracle\Java\javapath'),''

$env:Path.Split(';').Count

#endregion