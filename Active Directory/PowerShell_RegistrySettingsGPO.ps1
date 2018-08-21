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
Function Get-GPAllRegistryValues{
    [cmdletbinding()]
    param(
        [string]$key,
        [string]$gpoName
    )
    $current = Get-GPRegistryValue -Name $gpo -Key $key -ErrorAction SilentlyContinue
    If($current){
        Foreach($item in $current){
            If ($item.ValueName){
                $item
            }Else{
                Get-GPAllRegistryValues -Key $item.FullKeyPath -gpoName $gpo
            }
        }
    }
}
#endregion

$BaseKeys = 'HKCU\Software','HKLM\System','HKLM\Software'
$GPOs = Get-GPO -All

ForEach($GPO in $GPOs)