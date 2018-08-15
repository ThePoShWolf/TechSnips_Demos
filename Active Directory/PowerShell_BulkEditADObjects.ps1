#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt{}
Clear-Host
#endregion

#region notes

#endregion

#region Selecting users
#Filtering for all users
Get-ADUser -Filter *

#Filtering by a single attribute
Get-ADUser -Filter {Department -eq "IT"}
Get-ADUser -Filter {Title -like "Minion*"}

#Filtering by multiple attributes
Get-ADUser -Filter {(Manager -eq "noob-noob") -or (Company -eq "Vindicators")}
$1WeekAgo = (Get-Date).AddDays(-7)
$2WeeksAgo = (Get-Date).AddDays(-14)
Get-ADUser -Filter {(Created -gt $2WeeksAgo) -and (Created -lt $1WeekAgo)}

#Retrieving users by OU
Get-ADUser -SearchBase $OUPath

#Both
Get-ADUSer -SearchBase $OUPath -Filter {(Enabled -eq $true) -and (PasswordExpired -eq $false)}

#endregion

#region Bulk update examples

#Update UserPrincipalName (i.e. for O365)
#Pipeline, ForEach-Object
Get-ADUser -Filter {UserPrincipalName -notlike "*techsnips.io"} | `
%{Set-ADUser $_ -UserPrincipalName "$($_.SamAccountName)`@techsnips.io"}

#Foreach
ForEach($user in Get-ADUser -Filter {UserPrincipalName -notlike "*techsnips.io"}){
    Set-ADUser -Identity $user -UserPrincipalName "$($user.SamAccountName)`@techsnips.io"
}

#Reset password expiration date for C Levels
Get-ADUser -Filter {Enabled -eq $true} -SearchBase 'OU=Chiefs,'
ForEach($user in Get-ADUser -Filter {Enabled -eq $true} -SearchBase 'OU=Chiefs,'){
    $user.pwdlastset = 0
    Set-ADUser -Instance $user
    $user.pwdlastset = -1
    Set-ADUser -Instance $user
}

#Add users by title into groups
ForEach($user in Get-ADUser -Filter {Title -eq 'Teller'}){
    Add-ADGroupMember 'Tellers' -Members $user.SamAccountName
}

#Make sure each user is a member of their department group
#$user.Department = Human Resources
#Group = Human Resources Department
ForEach($user in Get-ADUser -Filter {Enabled -eq $true} -SearchBase 'OU=People' -Properties Department,MemberOf){
    If($user.MemberOf -replace '(CN=)*(,.*)*' -notcontains "$($user.Department) Department"){
        Add-ADGroupMember "$($user.Department) Department" -Members $user.SamAccountName
    }
}

#endregion