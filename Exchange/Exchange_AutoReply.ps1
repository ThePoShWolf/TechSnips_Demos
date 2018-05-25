#region demo header
Throw 'This is a demo, dummy!'
#endregion

#region prep
. 'C:\Program Files\Microsoft\Exchange Server\V15\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto -ClientApplication:ManagementShell
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region demo

Get-PSSession

$Enabled = @{
    'Identity' = ''
    'AutoReplyState' = 'Enabled'
    'ExternalAudience' = 'All'
    'InternalMessage' = 'I am currently out of the office binge watching TechSnips.io.'
    'ExternalMessage' = 'I am currently out of the office'
}

Set-MailboxAutoReplyConfiguration @Enabled

Get-MailboxAutoReplyConfiguration $Enabled.Identity

$MessageHTML = @"
<html>
    <head>
        <style type="text/css" style="display:none">
            <!--
                p
                {margin-top:0;
                margin-bottom:0}
            -->
        </style>
    </head>
    <body dir="ltr">
        <div id="divtagdefaultwrapper" dir="ltr" style="font-size:12pt; color:#000000; font-family:Calibri,Helvetica,sans-serif">
            <p>Hello,</p>
            <p><br></p>
            <p>Thanks for reaching out! I will be out of the office binge watching snips on TechSnips.io. Please reach out to my manager until I finish.</p>
            <p><br></p>
            <p>Thanks,</p>
            <p>Anthony<br></p>
        </div>
    </body>
</html>
"@

$Scheduled = @{
    'Identity' = ''
    'AutoReplyState' = 'Scheduled'
    'StartTime' = (Get-Date).AddDays(1)
    'EndTime' = (Get-Date).AddDays(7)
    'InternalMessage' = $MessageHTML
    'ExternalAudience' = 'Known'
    'ExternalMessage' = $MessageHTML
}

Set-MailboxAutoReplyConfiguration @Scheduled

Get-MailboxAutoReplyConfiguration $Scheduled.Identity

#endregion