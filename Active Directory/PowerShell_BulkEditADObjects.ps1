#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt{}
Clear-Host
#endregion

#region notes
#OUs
$OUPath = 'OU=People,DC=techsnips,DC=local'
'Chiefs','Minions' | %{New-ADOrganizationalUnit $_ -Path $OUPath}

#users
'Roy','Maurice','Jen','Richmond' | %{New-ADUser $_ -Department 'IT' -Company 'Reynholm Industries'}
'Roy','Maurice' | %{Set-ADUser $_ -Title 'Service Desk Tech'}
'Douglas Reynholm','Denholm Reynholm' | %{New-ADUser $_ -Department 'Chiefs' -Company 'Reynholm Industries'}
Set-ADuser 'Jen' -Title 'Relationship Manager'
'Douglas Reynholm','Denholm Reynholm' | %{Set-ADUser $_ -Title 'Chief Executive Officer'}
'Douglas Reynholm','Denholm Reynholm' | %{Set-ADAccountPassword $_ -Reset -NewPassword 'Something!Long@And#Random$'}
'Roy','Maurice','Richmond' | %{Set-ADUser $_ -Manager 'Jen'}

#groups
'IT Department','Chiefs Department',"Minions of Jen" | %{New-ADGroup $_ -GroupScope Universal -GroupCategory Security}

#clean
'Roy','Maurice','Jen','Richmond','Douglas Reynholm','Denholm Reynholm' | %{Remove-ADUser $_ -Confirm:$false}
'IT Department','Chiefs Department','Minions of Jen' | %{Remove-ADGroup $_ -Confirm:$false}
"OU=Chiefs,$OUPath","OU=Minions,$OUPath" | %{Remove-ADOrganizationalUnit $_ -Confirm:$false}
#endregion

#region Selecting users
#Filtering for all users
Get-ADUser -Filter *

#Filtering by a single attribute
Get-ADUser -Filter {Department -eq "IT"}
Get-ADUser -Filter {Title -like "*Manager"}

#Filtering by multiple attributes
Get-ADUser -Filter {(Department -eq "IT") -and (Manager -eq "Jen")}
$1WeekAgo = (Get-Date).AddDays(-7)
$2WeeksAgo = (Get-Date).AddDays(-14)
Get-ADUser -Filter {(Created -gt $2WeeksAgo) -and (Created -lt $1WeekAgo)}

#Retrieving users by OU
$OUPath = 'OU=People,DC=techsnips,DC=local'
Get-ADUser -SearchBase $OUPath

#Both
Get-ADUSer -SearchBase $OUPath -Filter {(Enabled -eq $true) -and (PasswordExpired -eq $false)}

#endregion

#region Bulk update examples

#Update UserPrincipalName (i.e. for O365)
#Pipeline, ForEach-Object
Get-ADUser -Filter {UserPrincipalName -notlike "*techsnips.io"}

Get-ADUser -Filter {UserPrincipalName -notlike "*techsnips.io"} | `
%{Set-ADUser $_ -UserPrincipalName "$($_.SamAccountName)`@techsnips.io"}

Get-ADUser -Filter {UserPrincipalName -notlike "*techsnips.io"}

#Foreach
ForEach($user in Get-ADUser -Filter {UserPrincipalName -notlike "*techsnips.io"}){
    Set-ADUser -Identity $user -UserPrincipalName "$($user.SamAccountName)`@techsnips.io"
}

#Reset password expiration date for C Levels
Get-ADUser -Filter {Enabled -eq $true} -SearchBase "OU=Chiefs,$OUPath" -Properties PasswordLastSet | Format-Table Name,PasswordLastSet

ForEach($user in Get-ADUser -Filter {Enabled -eq $true} -SearchBase 'OU=Chiefs,'){
    $user.pwdlastset = 0
    Set-ADUser -Instance $user
    $user.pwdlastset = -1
    Set-ADUser -Instance $user
}
Get-ADUser -Filter {Enabled -eq $true} -SearchBase "OU=Chiefs,$OUPath" -Properties PasswordLastSet | Format-Table Name,PasswordLastSet

#Add users by title into groups
ForEach($user in Get-ADUser -Filter {Title -eq 'Service Desk Tech'}){
    Write-Host "Adding $($user.name) to group: Minions of Jen"
    Add-ADGroupMember 'Minions of Jen' -Members $user.SamAccountName
}
Get-ADGroupMember 'Minions of Jen'

#Make sure each user is a member of their department group
#$user.Department = Human Resources
#Group = Human Resources Department
ForEach($user in Get-ADUser -Filter {Enabled -eq $true} -SearchBase "OU=Minions,$OUPath" -Properties Department,MemberOf){
    If($user.MemberOf -replace '(CN=)*(,.*)*' -notcontains "$($user.Department) Department"){
        Write-Host "Adding $($user.name) to group: $($user.Department) Department"
        Add-ADGroupMember "$($user.Department) Department" -Members $user.SamAccountName
    }
}

#endregion