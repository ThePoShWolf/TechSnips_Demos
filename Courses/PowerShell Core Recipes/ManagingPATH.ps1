# Path location
$env:Path

# Updating
$env:Path += ';C:\tmp'

# Demonstration
executeme.ps1

New-Item C:\tmp\executeme.ps1 -Value "Write-Host 'Hello from executeme.ps1'"

Get-Location
executeme.ps1