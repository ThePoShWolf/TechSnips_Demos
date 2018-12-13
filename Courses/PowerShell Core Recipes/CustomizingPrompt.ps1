# Default
# Find current code
(Get-Command Prompt).ScriptBlock

Function prompt{
    "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
}

# Simplest
Function prompt{}

# Simple Examples
Function prompt {
    (Get-Date).ToShortTimeString()
}

Function prompt{
    "¯\_(ツ)_/¯ > "
}

# PS version, time, admin
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

# Multi-Line
# User, computer, directory, time
Function prompt{
    $prompt = "$($env:USERNAME)@$($env:USERDOMAIN)"
    $prompt += " | $($env:COMPUTERNAME)"

    $loc = (Get-Location).ToString().Replace($Home,'~')
    $loc = $loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2'

    $prompt += " | $loc"
    $items = Get-ChildItem (Get-Location)
    $prompt += " - $($items.count)"
    $prompt += " | $(Get-Date -Format 'HH:mm:ss')"
    #$prompt += " | "
    $prompt += "`nPS"
    If($IsWindows){
        If([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")){
            $prompt += '#'
        }
    }ElseIf($IsLinux){
        If((whoami) -eq 'root'){
            $prompt += '#'
        }
    }
    $prompt += "> "
    $prompt
}