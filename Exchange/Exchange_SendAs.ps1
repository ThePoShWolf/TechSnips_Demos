#region demo header
Throw 'This is a demo, dummy!'
#endregion

#region prep
. 'C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto -ClientApplication:ManagementShell
New-Mailbox 'President of the twelve colonies' -UserPrincipalName president@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
New-DistributionGroup 'Cylons'
New-Mailbox 'Laura Roslin' -UserPrincipalName lauraroslin@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
New-Mailbox 'Richard Adar' -UserPrincipalName richardadar@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
New-Mailbox 'Brother Cavil' -UserPrincipalName number1@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
New-Mailbox 'Leoben Conoy' -UserPrincipalName number2@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
New-Mailbox "D'Anna Biers" -UserPrincipalName number3@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
New-Mailbox 'Simon' -UserPrincipalName number4@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
New-Mailbox 'Aaron Doral' -UserPrincipalName number5@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
New-Mailbox 'Number Six' -UserPrincipalName number6@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
New-Mailbox 'Boomer' -UserPrincipalName number8@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
New-Mailbox 'Samuel Anders' -UserPrincipalName number9@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
New-Mailbox 'Saul Tigh' -UserPrincipalName number10@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
New-Mailbox 'Galen Tyrol' -UserPrincipalName number11@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
New-Mailbox 'Tory Foster' -UserPrincipalName number12@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
New-Mailbox 'Ellen Tigh' -UserPrincipalName number13@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
New-Mailbox 'William Adama' -UserPrincipalName williamadama@techsnipsdemo.org -Password (ConvertTo-SecureString 'Password1!' -AsPlainText -Force)
#endregion

#region clean
Set-Mailbox president -GrantSendOnBehalfTo richardadar
Set-DistributionGroup cylons -GrantSendOnBehalfTo number1,number2,number3,number4,number5,number6
Function Prompt(){}
Clear-Host
#endregion

#region demo

#region mailbox

#Get the Mailbox
Get-Mailbox -Identity President

#Get the current send-as permission for a user
Get-Mailbox -Identity President | Select-Object -Property GrantSendOnBehalfTo

#Grant send-as for the mailbox
Set-Mailbox -Identity President -GrantSendOnBehalfTo 'Laura Roslin'

#endregion

#region distribution group

#Get the current send-as permission for a distribution group
Get-DistributionGroup -Identity Cylons | Select-Object -Property GrantSendOnBehalfTo

#Nicely format said permissions
(Get-DistributionGroup -Identity Cylons).GrantSendOnBehalfTo | Select-Object -Property Name

#Set the send-as permission for a distribution group
Set-DistributionGroup -Identity Cylons -GrantSendOnBehalfTo @{Add='Boomer'}

#endregion