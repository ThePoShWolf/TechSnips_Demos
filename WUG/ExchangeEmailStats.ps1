#region Messages Received
$PollMinutes = 5
$HostName = ([System.Net.Dns]::GetHostEntry($Context.GetProperty("Address"))).HostName

$s = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://$HostName/PowerShell/" -Authentication Kerberos
Import-PSSession $s -commandname Get-MessageTrackingLog | Out-Null

$start = (Get-date).addminutes(-$PollMinutes)
$end = (Get-Date)
$TotalRec = Get-MessageTrackingLog -ResultSize Unlimited -Start $start -End $end -eventID "RECEIVE"
$TotalRec.count
#endregion

#region Messages Sent
$PollMinutes = 5
$HostName = ([System.Net.Dns]::GetHostEntry($Context.GetProperty("Address"))).HostName

$s = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://$HostName/PowerShell/" -Authentication Kerberos
Import-PSSession $s -commandname Get-MessageTrackingLog | Out-Null

$start = (Get-date).addminutes(-$PollMinutes)
$end = (Get-Date)
$TotalSent = Get-MessageTrackingLog -ResultSize Unlimited -Start $start -End $end -eventID "SEND"
$TotalSent.count
#endregion