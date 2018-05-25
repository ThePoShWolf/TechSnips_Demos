#region demo
Throw 'This is a demo, dummy!'
#endregion

#region prep
. 'C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto -ClientApplication:ManagementShell
#endregion

#region clean
Remove-Mailbox 'BenderRodriguez@techsnipsdemo.org' -Confirm:$false
Disable-Mailbox 'Philip J. Fry' -Confirm:$false
Remove-Mailbox 'ship@techsnipsdemo.org' -Confirm:$false
Function Prompt(){}
Clear-Host
#endregion

#region demo

Get-PSSession

#region AD User

Get-ADUser -Identity 'Philip J. Fry' -Properties EmailAddress | Format-Table Name,EmailAddress

Enable-Mailbox -Identity 'Philip J. Fry'

Get-ADUser -Identity 'Philip J. Fry' -Properties EmailAddress | Format-Table Name,EmailAddress

Get-Mailbox -Identity 'Philip J. Fry'

#endregion

#region Standalone

$Mailbox = @{
    'Password' = ConvertTo-SecureString 'P@ssword1!' -AsPlainText -Force
    'Name' = 'Bender Rodriguez'
    'UserPrincipalName' = 'BenderRodriguez@techsnipsdemo.org'
    'FirstName' = 'Bender'
    'LastName' = 'Rodriguez'
    'Database' = 'TechSnipsDemoDB'
    'ResetPasswordOnNextLogon' = $true
}

New-Mailbox @Mailbox

Get-Mailbox -Identity 'BenderRodriguez@techsnipsdemo.org'

Get-ADUser -Identity 'BenderRodriguez'

#endregion

#region resource

$ResourceMailbox = @{
    'Room' = $true
    'Name' = 'Ship'
    'DisplayName' = 'Planet Express Ship'
}
New-Mailbox @ResourceMailbox

$CalendarProcessing = @{
    'Identity' = 'Ship@techsnipsdemo.org'
    'AllowConflicts' = $false
    'AllowRecurringMeetings' = $true
    'AutomateProcessing' = 'AutoAccept'
    'BookingWindowInDays' = 365
    'MaximumDurationInMinutes' = 600
    'ProcessExternalMeetingMessages' = $false
}
Set-CalendarProcessing @CalendarProcessing

Get-CalendarProcessing $CalendarProcessing.Identity

#endregion

#endregion