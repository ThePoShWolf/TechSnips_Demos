#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region New-ADReplicationSite

#We have no replication sites besides the default
Get-ADReplicationSite

#So lets create one
New-ADReplicationSite Moon

Get-ADReplicationSite Moon

#Or another with a schedule
$schedule = New-Object -TypeName System.DirectoryServices.ActiveDirectory.ActiveDirectorySchedule
$schedule.ResetSchedule()
$schedule.SetDailySchedule("Twenty","Zero","TwentyThree","FortyFive")
New-ADReplicationSite -Name 'Mars' -ReplicationSchedule $schedule -Description 'Where men are from'

Get-ADReplicationSite -Identity 'Mars'
(Get-ADReplicationSite -Identity 'Mars').ReplicationSchedule

#And a third because I want three
$Site2Copy = Get-ADReplicationSite 'Mars'
New-ADReplicationSite -Name 'Venus' -Description 'Where women are from' -Instance $Site2Copy

Get-ADReplicationSite -Identity 'Venus'
(Get-ADReplicationSite -Identity 'Venus').ReplicationSchedule
#endregion

#region Get-ADReplicationSite

Get-ADReplicationSite

#endregion

#region Remove-ADReplicationSite

#endregion

#region Set-ADReplicationSite

#endregion