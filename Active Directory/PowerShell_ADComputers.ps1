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
#Get one computer
Get-ADComputer -Identity 'Sierra'

#Filter for all computers
Get-ADComputer -Filter *

#Filter for all Server 2016
Get-ADComputer -Filter {OperatingSystem -like '*2016*' }

#Get additional properties
Get-ADComputer -Identity 'Sierra' -Properties *

Get-ADComputer -Identity 'Sierra' -Properties IPv4Address

#Get computers from a specific OU
Get-ADComputer -Filter * -SearchBase 'OU=Super Computers,OU=Machines,DC=techsnips,DC=local'

#endregion

#region Set-ADComputer

#Certain properties
Set-ADComputer -Identity 'Summit' -Enabled $False

$SetCompSplat = @{
    Identity = 'Summit'
    DisplayName = "DoE's finest."
    Location = 'Oak Ridge National Laboratory'
}
Set-ADComputer @SetCompSplat

#Properties without explicit parameter
$Comp = Get-ADComputer -Identity 'Summit'
$Comp.PrimaryGroup = ''

#endregion

#region Remove-ADComputer

Remove-ADComputer -Identity 'Sierra'

$20mAgo = (Get-Date).AddMinutes(-20)
Get-ADComputer -Filter {Created -gt $20mAgo}
Get-ADComputer -Filter {Created -gt $20mAgo} | Remove-ADComputer -Confirm:$false

#endregion