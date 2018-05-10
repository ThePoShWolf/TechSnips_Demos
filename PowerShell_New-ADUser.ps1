#region demo
Throw "This is a demo, dummy!"
#endregion
#region prep
Import-Module ActiveDirectory
#endregion
#region clean
Function Prompt(){}
Remove-ADUser "Anthony Howell" -Confirm:$false
Remove-ADUser "Franz.Ferdinand" -Confirm:$false
Clear-Host
#endregion

#region prereqs

Get-Module ActiveDirectory

#endregion

#region simple

New-ADUser -Name 'Anthony Howell'
Get-ADUser 'Anthony Howell'

#endregion

#region complex

$NewUser = @{
    'GivenName' = 'Franz'
    'Surname' = 'Ferdinand'
    'Name' = 'Franz Ferdinand'
    'Title' = 'Archduke'
    'SamAccountName' = 'Franz.Ferdinand'
    'UserPrincipalName' = 'Franz.Ferdinand@techsnipsdemo.org'
    'Manager' = 'Anthony Howell'
}
New-ADUser @NewUser

Get-ADUser Franz.Ferdinand

#endregion