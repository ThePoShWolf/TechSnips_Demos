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

#region Set-ADReplicationSite

#Match up the replication schedules
Set-ADReplicationSite 'Moon' -ReplicationSchedule $schedule

#Reset the schedule
$schedule.ResetSchedule()
$schedule.SetDailySchedule("TwentyOne","Zero","TwentyThree","FortyFive")
Get-ADReplicationSite -Filter {Name -notlike '*default*'} | Set-ADReplicationSite -ReplicationSchedule $schedule

#Other properties
Get-ADReplicationSite -Filter * | Set-ADReplicationSite -ScheduleHashingEnabled $false

Get-ADReplicationSite -Filter * -Properties ScheduleHashingEnabled | Format-Table Name,ScheduleHashingEnabled

#Intersite topology generator
Set-ADReplactionSite 'Mars' -InterSiteTopologyGenerator 'Prod-DC'

#endregion

#region Remove-ADReplicationSite

#Remove one site
Remove-ADReplicationSite 'Moon'

Get-ADReplicationSite 'Moon'

#Remove sites using a filter
$20mAgo = (Get-Date).AddMinutes(-20)
Get-ADReplicationSite -Filter {Create -gt $20mAgo}

Get-ADReplicationSite -Filter {Created -gt $20mAgo} | Remove-ADReplicationSite

Get-ADReplicationSite -Filter {Create -gt $20mAgo}

#endregion