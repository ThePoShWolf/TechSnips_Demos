#region demo header
Throw 'This is a demo, dummy!'
#endregion

#region prep
. 'C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto -ClientApplication:ManagementShell
#endregion

#region clean
Remove-Mailbox 'BenderRodriguez@techsnipsdemo.org' -Confirm:$false
Disable-Mailbox 'Philip J. Fry' -Confirm:$false
Function Prompt(){}
Clear-Host
#endregion

#region demo

Get-PSSession

#region Create a mailbox for an existing AD user
Get-ADUser -Identity 'Philip J. Fry' -Properties EmailAddress | Format-Table Name,EmailAddress

#Create the mailbox in Exchange
Enable-Mailbox -Identity 'Philip J. Fry' -Database 'TechSnipsDemoDB'

#Look at the email address property in AD
Get-ADUser -Identity 'Philip J. Fry' -Properties EmailAddress | Format-Table Name,EmailAddress

#Look at the shiny new mailbox
Get-Mailbox -Identity 'Philip J. Fry'

#endregion

#region Create a mailbox without an existing AD user
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

#Check Exchange
Get-Mailbox -Identity 'BenderRodriguez@techsnipsdemo.org'

#Check AD
Get-ADUser -Identity 'BenderRodriguez'

#endregion

#region Manage SMTP addresses
Get-Mailbox -Identity 'BenderRodriguez' | Format-List EmailAddresses

#Set the email address to a single SMTP address
$Bender = @{
    'Identity' = 'BenderRodriguez'
    'EmailAddressPolicyEnabled' = $false
    'EmailAddresses' = 'Bender@ProjectScissorsDemo.org'
}
Set-Mailbox -Identity 'BenderRodriguez' -EmailAddressPolicyEnabled $false -EmailAddresses 'BenderR@ProjectScissorsDemo.org'

#Check the new address
Get-Mailbox -Identity 'BenderRodriguez' | Format-List EmailAddresses

#Add and remove email addresses, specifying a primary SMTP address
$NewBender = @{
    'Identity' = 'BenderRodriguez'
    'EmailAddressPolicyEnabled' = $false
    'EmailAddresses' = @{
        Add='SMTP:Bender@TechSnipsDemo.org','Bender@ProjectScissorsDemo.org';
        Remove='BenderR@ProjectScissorsDemo.org'
    }
}
Set-Mailbox @NewBender

#Check the new addresses
Get-Mailbox -Identity 'BenderRodriguez' | Format-List EmailAddresses

#endregion

#region Disable a mailbox
Disable-Mailbox -Identity 'Philip J. Fry' -Confirm:$false

#Check AD
Get-ADUser -Identity 'Philip J. Fry'

#Check Exchange
Get-Mailbox -Identity 'Philip J. Fry'

#endregion

#region Remove a mailbox
Remove-Mailbox -Identity 'BenderRodriguez' -Confirm:$false

#Check AD
Get-ADUser -Identity 'BenderRodriguez'

#Check Exchange
Get-Mailbox -Identity 'BenderRodriguez'

#endregion

#endregion