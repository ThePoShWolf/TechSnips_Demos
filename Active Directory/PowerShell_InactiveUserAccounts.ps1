#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region Search-ADAccount

#By time span
Search-ADAccount -AccountInactive -TimeSpan '30.00:00:00'

Search-ADAccount -AccountInactive -TimeSpan (New-TimeSpan -Days 30)

#By date
Search-ADAccount -AccountInactive -DateTime "08/10/2018 00:00:00"

Search-ADAccount -AccountInactive -DateTime (Get-Date).AddDays(-30)

#Removing the users
Search-ADAccount -AccountInactive -TimeSpan '30.00:00:00' -UsersOnly |`
Remove-ADUser -WhatIf

#endregion

#region Avoiding newly created accounts

#Using search base
Search-ADAccount -AccountInactive -DateTime (Get-Date).AddDays(-10) -SearchBase ''

#Or using Get-ADUser -filter
$date = (Get-Date).AddDays(-10)
Get-ADUser -Filter {LastLogonDate -lt $date}
Get-ADUser -Filter {LastLogonDate -notlike "*"}
Get-ADUser -Filter {Created -lt $date}

#All together
$filter = {
    ((LastLogonDate -lt $date) -or (LastLogonDate -notlike "*"))
    -and (Created -lt $date)
}

Get-ADUser -Filter $filter | Remove-ADUser -WhatIf

#endregion