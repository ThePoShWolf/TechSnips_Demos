#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region New-ADComputer
#simplest
New-ADComputer 'Summit'

#Set more properties
$NewCompSplat01 = @{
    Name = 'Sunway TaihuLight'
    SamAccountName = 'Sunway.TaihuLight'
    Path = 'OU=Super Computers,OU=Machines,DC=techsnips,DC=local'
    Enabled = $true
}
New-ADComputer @NewCompSplat01

#Copy from template computer
$GetCompSplat = @{
    Identity = 'Sunway.TaihuLight'
    Properties = 'Location','OperatingSystem','OperatingSystemHotfix','OperatingSystemServicePack','OperatingSystemVersion'
}
$templateComp = Get-ADComputer @GetCompSplat
New-ADComputer -Instance $templateComp -Name 'Sierra'
#endregion

#region Get-ADComputer

#endregion

#region Set-ADComputer

#endregion

#region Remove-ADComputer

#endregion