#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region Basic how-to

$GPOName = 'Default Domain Policy'

Get-GPRegistryValue -Name $GPOName -Key 'HKLM\Software'

Get-GPRegistryValue -Name $GPOName -Key 'HKLM\Software\Policies'

Get-GPRegistryValue -Name $GPOName -Key 'HKLM\Software\Policies\Microsoft\SystemCertificates\EFS'

#endregion

#region Recursive function
#https://github.com/gpoguy/ADMXToDSC/blob/master/ADMXToDSC.PS1
#Lines 73-107, Recurse_PolicyKeys
Function Get-GPRecursiveRegistryValues{
    [cmdletbinding()]
    Param(
        [string]$GPOName,
        [string]$Key
    )
    $current = Get-GPRegistryValue -Name $GPOName -Key $Key -ErrorAction SilentlyContinue
    Foreach($item in $current){
        If ($item.ValueName){
            $item
        }Else{
            Get-GPRecursiveRegistryValues -Key $item.FullKeyPath -gpoName $GPOName
        }
    }
}
#Usage
Get-GPRecursiveRegistryValues -GPOName 'Default Domain Policy' -Key 'HKLM\System'

Get-GPRecursiveRegistryValues -GPOName 'Default Domain Policy' -Key 'HKCU\Software'

#endregion

#region Make it one function!

#region what we need
$BaseKeys = 'HKLM\System','HKLM\Software','HKCU\Software'
$GPOName = 'IT'

ForEach($Key in $BaseKeys){
    Get-GPRecursiveRegistryValues -GPOName $GPOName -Key $Key
}

#endregion

#region function

Function Get-GPAllRegistryValues{
    Param(
        [Parameter(
            ValueFromPipelineByPropertyName = $true
        )]
        [Alias('DisplayName')]
        [string]$Name
    )
    Begin{
        $BaseKeys = 'HKLM\System','HKLM\Software','HKCU\Software'
        Function Get-GPRecursiveRegistryValues{
            [cmdletbinding()]
            Param(
                [string]$GPOName,
                [string]$Key
            )
            $current = Get-GPRegistryValue -Name $GPOName -Key $Key -ErrorAction SilentlyContinue
            Foreach($item in $current){
                If ($item.ValueName){
                    $item
                }Else{
                    Get-GPRecursiveRegistryValues -Key $item.FullKeyPath -gpoName $GPOName
                }
            }
        }

    }
    Process{
        ForEach($Key in $BaseKeys){
            Get-GPRecursiveRegistryValues -GPOName $Name -Key $Key
        }
    }
    End{}
}

#Usage
#One Policy
Get-GPAllRegistryValues -Name 'IT'

Get-GPO -Name 'IT' | Get-GPAllRegistryValues

#Multiple
Get-GPO -All | Where-Object DisplayName -like 'Default*' | Get-GPAllRegistryValues

#All
Get-GPO -All | Get-GPAllRegistryValues

#endregion

#endregion