# Windows
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

Write-Host "Welcome $($env:USERNAME), it is $(Get-Date -Format 'HH:mm:ss')"

Function Go-Home{
    Set-Location $env:USERPROFILE
}

# Linux
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

Write-Host "Welcome $($env:USER), it is $(Get-Date -Format 'HH:mm:ss')"

Function Go-Home{
    Set-Location ~
}