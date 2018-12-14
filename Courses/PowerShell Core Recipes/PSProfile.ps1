# Windows
# Location: $profile

#region Prep
$profile
$profile = 'C:\Users\Anthony\Documents\PowerShell\Microsoft.PowerShell_profile.ps1'
If(-not(Test-Path $profile)){
    New-Item $profile -ItemType File
}
#endregion

#region Profile example
Function prompt {
    $prompt = 'pwsh '
    $prompt += "[$($PSVersionTable.PSVersion)] "
    $prompt += "$(Get-Date -Format 'HH:mm:ss')"
    If($IsWindows){
        If([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")){
            $prompt += '#'
        }
    }ElseIf($IsLinux){
        If((whoami) -eq 'root'){
            $prompt += '#'
        }
    }
    "$prompt> "
}

$env:Path += ';C:\tmp'

$cityID = '5725846'
$weatherAPIKey = Get-Content C:\users\Anthony\Documents\OpenWeatherAPI.txt
$url = "https://api.openweathermap.org/data/2.5/weather?id=$cityID&APPID=$weatherAPIKey"
$resp = Invoke-RestMethod -Uri $url -Method Get

Write-Host "Welcome $($env:USERNAME), it is $(Get-Date -Format 'HH:mm:ss')"
Write-Host "The weather is currently: $($resp.weather.description)"

Function Go-Home{
    Set-Location $env:USERPROFILE
}
#endregion

# Linux and macOS
# Location: ~/.config/powershell/profile.ps1\

#region Prep
$profilePath = '~/.config/powershell/profile.ps1'
If(-not(Test-Path $profilePath)){
    If(-not(Test-Path (Split-Path $profilePath))){
        New-Item (Split-Path $profilePath) -ItemType Directory
    }
    New-Item $profilePath -ItemType File
}
#endregion

#region Profile example
Function prompt {
    $prompt = 'pwsh '
    $prompt += "[$($PSVersionTable.PSVersion)] "
    $prompt += "$(Get-Date -Format 'HH:mm:ss')"
    If($IsWindows){
        If([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")){
            $prompt += '#'
        }
    }ElseIf($IsLinux){
        If((whoami) -eq 'root'){
            $prompt += '#'
        }
    }
    "$prompt> "
}

$env:Path += ':/usr/tmp'
$cityID = '5725846'
$weatherAPIKey = Get-Content ~/Documents/OpenWeatherAPI.txt
$url = "https://api.openweathermap.org/data/2.5/weather?id=$cityID&APPID=$weatherAPIKey"
$resp = Invoke-RestMethod -Uri $url -Method Get

Write-Host "Welcome $($env:USER), it is $(Get-Date -Format 'HH:mm:ss')"
Write-Host "The weather is currently: $($resp.weather.description)"



Function Go-Home{
    Set-Location ~
}
#endregion