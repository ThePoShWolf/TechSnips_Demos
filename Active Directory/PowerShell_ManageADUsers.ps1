#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region Creating

#region Basics
New-ADUser 'Anthony Howell'

Get-ADUser 'Anthony Howell'
#endregion

#region Complex
$NewExecutive = @{
    'GivenName' = 'Franz'
    'Surname' = 'Ferdinand'
    'Name' = 'Franz Ferdinand'
    'DisplayName' = 'Franz Ferdinand'
    'SamAccountName' = 'Franz.Ferdinand'
    'UserPrincipalName' = 'Franz.Ferdinand@techsnipsdemo.org'
    'EmailAddress' = 'Franz.Ferdinand@techsnipsdemo.org'
    'Title' = 'Archduke'
    'Department' = 'Executives'
    'Country' = 'AT'
    'Manager' = 'Anthony Howell'
    'AccountPassword' = (ConvertTo-SecureString 'SecurePassword1!' -AsPlainText -Force)
}
New-ADUser @NewExecutive

$Properties = 'GivenName','SurName','Name','DisplayName','SamAccountName','UserPrincipalName','EmailAddress','Title','Department','Country','Manager'

# Using the -Properties parameter to specify which properties to return
Get-ADUser -Identity Franz.Ferdinand -Properties $Properties | Select-Object $Properties
#endregion

#endregion

#region Getting

#region Filtering for all users
Get-ADUser -Filter * | Format-Table Name
#endregion

#region Filtering by a single attribute
Get-ADUser -Filter {Department -eq "IT"} | Format-Table Name

Get-ADUser -Filter {Title -like "*Manager"} | Format-Table Name
#endregion

#region Filtering by multiple attributes
Get-ADUser -Filter {(Department -eq "IT") -and (Manager -eq "Jen")} | Format-Table Name

$before = (Get-Date).AddDays(-2)
$after = (Get-Date).AddDays(-6)
Get-ADUser -Filter {(Created -gt $after) -and (Created -lt $before)} | Format-Table Name
#endregion

#region Retrieving users by OU
$OUPath = 'OU=People,DC=techsnips,DC=local'
Get-ADUser -Filter * -SearchBase $OUPath | Format-Table Name
#endregion

#region Both a filter and OU
Get-ADUSer -SearchBase $OUPath -Filter {(Enabled -eq $true) -and (PasswordExpired -eq $false)} | Format-Table Name
#endregion

#endregion

#region Setting

#region Attributes with parameters
Set-ADUser 'Anthony Howell' -Title 'Overlord' -Department 'Management'
#endregion

#region Attributes without parameters
$user = Get-ADUser 'Anthony Howell' -Properties IPPhone
$user.IPPhone = 7647
Set-ADUser -Instance $user
#endregion
#region 

#endregion

#endregion

#region Removing

Get-ADUser -Identity 'GPOTest'

Remove-ADUser -Identity 'GPOTest' -Confirm:$false

Get-ADUser -Identity 'GPOTest'

#endregion